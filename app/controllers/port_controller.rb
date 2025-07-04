class PortController < ApplicationController
  require "socket"
  require "timeout"
  require "httparty"

  HOST    = "nexus.melon.cl"
  PORT    = 569
  TIMEOUT = 5  # segundos
  URL     = "https://#{HOST}:#{PORT}/LlamadoCamiones/LlamadoLCA.aspx"

  def check
    @open = port_open?(HOST, PORT, TIMEOUT)

    # Hacemos la petición HTTP y guardamos el HTML completo
    response = HTTParty.get(URL, verify: false)
    @html = response.body
  rescue StandardError => e
    @html = "<p style='color:red;'>Error al obtener HTML: #{e.message}</p>"
  end

  private

  def port_open?(host, port, timeout_sec)
    Timeout.timeout(timeout_sec) do
      Socket.tcp(host, port) { |sock| sock.close }
      true
    end
  rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, SocketError, Timeout::Error
    false
  end
end
