<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="20008000">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Kontrolki" Type="Folder">
			<Item Name="Dane.ctl" Type="VI" URL="../Kontrolki/Dane.ctl"/>
			<Item Name="Parametry_cosinusa.ctl" Type="VI" URL="../Kontrolki/Parametry_cosinusa.ctl"/>
			<Item Name="Parametry_cosinusow.ctl" Type="VI" URL="../Kontrolki/Parametry_cosinusow.ctl"/>
			<Item Name="Rodzaj_modulacji.ctl" Type="VI" URL="../Kontrolki/Rodzaj_modulacji.ctl"/>
			<Item Name="Rodzaj_wzmacniacza.ctl" Type="VI" URL="../Kontrolki/Rodzaj_wzmacniacza.ctl"/>
			<Item Name="Pasmo_przenoszenia.ctl" Type="VI" URL="../Kontrolki/Pasmo_przenoszenia.ctl"/>
		</Item>
		<Item Name="SubVI" Type="Folder">
			<Item Name="Generator_cosinusa.vi" Type="VI" URL="../SubVI/Generator_cosinusa.vi"/>
			<Item Name="Generator_sygnalu_modulujacego.vi" Type="VI" URL="../SubVI/Generator_sygnalu_modulujacego.vi"/>
			<Item Name="Przesuwnik_fazowy.vi" Type="VI" URL="../SubVI/Przesuwnik_fazowy.vi"/>
			<Item Name="Wzmacniacz.vi" Type="VI" URL="../SubVI/Wzmacniacz.vi"/>
			<Item Name="Modulator_USBSC.vi" Type="VI" URL="../SubVI/Modulator_USBSC.vi"/>
			<Item Name="Modulator_LSBSC.vi" Type="VI" URL="../SubVI/Modulator_LSBSC.vi"/>
			<Item Name="Synchronizator_DSBSC.vi" Type="VI" URL="../SubVI/Synchronizator_DSBSC.vi"/>
			<Item Name="Demodulacja_DSBFC.vi" Type="VI" URL="../SubVI/Demodulacja_DSBFC.vi"/>
			<Item Name="Demodulacja_DSBFC_2.vi" Type="VI" URL="../SubVI/Demodulacja_DSBFC_2.vi"/>
			<Item Name="Demodulacja_DSBSC.vi" Type="VI" URL="../SubVI/Demodulacja_DSBSC.vi"/>
			<Item Name="Demodulacja_SSBSC.vi" Type="VI" URL="../SubVI/Demodulacja_SSBSC.vi"/>
			<Item Name="Wzmacniacz_2.vi" Type="VI" URL="../SubVI/Wzmacniacz_2.vi"/>
		</Item>
		<Item Name="main_symulacyjny.vi" Type="VI" URL="../main_symulacyjny.vi"/>
		<Item Name="main_pomiarowy.vi" Type="VI" URL="../main_pomiarowy.vi"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="High Resolution Relative Seconds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/High Resolution Relative Seconds.vi"/>
				<Item Name="NI_AALPro.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALPro.lvlib"/>
				<Item Name="NI_MABase.lvlib" Type="Library" URL="/&lt;vilib&gt;/measure/NI_MABase.lvlib"/>
				<Item Name="NI_MAPro.lvlib" Type="Library" URL="/&lt;vilib&gt;/measure/NI_MAPro.lvlib"/>
				<Item Name="NI_AALBase.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALBase.lvlib"/>
			</Item>
			<Item Name="lvanlys.dll" Type="Document" URL="/&lt;resource&gt;/lvanlys.dll"/>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
