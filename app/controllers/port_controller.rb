class PortController < ApplicationController
  require "socket"
  require "timeout"

  HOST    = "nexus.melon.cl"
  PORT    = 569
  TIMEOUT = 5  # segundos

  def check
    @open = port_open?(HOST, PORT, TIMEOUT)
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
