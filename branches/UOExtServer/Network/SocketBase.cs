using System;

namespace UOExtDomain.Network
{
	/// <summary> 
	/// ���������� ��� ��������� ���������
	/// </summary>
	public delegate void MessageHandler(SocketBase socket, int iNumberOfBytes);
    
	/// <summary> 
	/// ���������� ��� �������� ����������
	///  </summary>
	public delegate void CloseHandler(SocketBase socket);
    
	/// <summary>
	/// ���������� ��� ������������� ������
	///  </summary>
	public delegate void ErrorHandler(SocketBase socket, Exception exception);

	public abstract class SocketBase : IDisposable
	{
		#region Variables

		/// <summary>
		/// ������ �� ���������������� ������
		/// </summary>
		protected internal Object userArg;

		/// <summary>
		/// ������ �� �����, ������� ����� ���������� ��� ��������� ���������
		/// </summary>
		protected internal MessageHandler messageHandler;

		/// <summary>
        /// ������ �� �����, ������� ����� ���������� ��� �������� ����������
		/// </summary>
		protected internal CloseHandler closeHandler;

		/// <summary>
        /// ������ �� �����, ������� ����� ���������� ��� ������������� ������
		/// </summary>
		protected internal ErrorHandler errorHandler;

		/// <summary>
		/// ���� ������������ ���� �� ����������� � �������� ��� ������� �������
		/// </summary>
		protected internal bool disposed;

		/// <summary>
		/// IP ������ � �������� ������������ ������
		/// </summary>
		protected internal string ipAddress;

		/// <summary>
		/// ���� ��� ���������� ��� �������������
		/// </summary>
		protected internal int port;

		/// <summary>
        /// ����� ��� ������ ������ �� ������
		/// </summary>
		protected internal byte[] rawBuffer;

		/// <summary>
        /// ������ ������ rawBuffer
		/// </summary>
		protected internal int sizeOfRawBuffer;

		#endregion
		
        #region Public Properties

		/// <summary> 
        /// IP ������ � �������� ������������ ������
		/// </summary>
		public string IpAddress 
		{ 
			get 
			{ 
				return this.ipAddress; 
			}
			set
			{ 
				this.ipAddress = value; 
			} 
		}

		/// <summary>
        /// ���� ��� ���������� ��� �������������
		/// </summary>
		public int Port 
		{ 
			get 
			{ 
				return this.port; 
			} 
			set
			{
				this.port = value; 
			}
		}

		/// <summary>
        /// ������ �� ���������������� ������
		/// </summary>
		public Object UserArg 
		{
			get 
			{
				return this.userArg; 
			} 
			set 
			{ 
				this.userArg = value; 
			} 
		}

		/// <summary>
        /// ����� ��� ������ ������ �� ������
		/// </summary>
		public byte[] RawBuffer 
		{ 
			get 
			{ 
				return this.rawBuffer; 
			} 
			set 
			{ 
				this.rawBuffer = value; 
			} 
		}

		/// <summary>
        /// ������ ������ RawBuffer
		/// </summary>
		public int SizeOfRawBuffer
		{ 
			get 
			{ 
				return this.sizeOfRawBuffer; 
			} 
			set 
			{ 
				this.sizeOfRawBuffer = value; 
			} 
		}


		#endregion Public Properties

		#region IDisposable Members

		public virtual void Dispose()
		{
		}

		#endregion
	}
}
