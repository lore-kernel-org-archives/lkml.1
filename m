Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440Ab0AIXqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0AIXqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808Ab0AIXqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:46:51 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:60198 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0AIXqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:46:51 -0500
Subject: Re: ACPI quirks - acpi_osi="!Windows 2006" required on FSC Amilo
 notebooks to enable brightness keys
From: Peter Paul <abnominales@web.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100109233802.GA20615@srcf.ucam.org>
References: <539929391@web.de> <20100109202642.GA18657@srcf.ucam.org>
	 <1263073701.6497.75.camel@rechenknecht2k7>
	 <20100109220606.GA19441@srcf.ucam.org> <1263076707.1675.6.camel@virtubuntu>
	 <20100109231122.GA19789@srcf.ucam.org>
	 <1263079195.20284.2.camel@virtubuntu>
	 <20100109232324.GA20504@srcf.ucam.org>
	 <1263079816.20284.3.camel@virtubuntu>
	 <20100109233802.GA20615@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jan 2010 00:46:04 +0100
Message-ID: <1263080764.20284.4.camel@virtubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+CYT+D28N40DHpVanl7jagV4UjVBNCU5hyagzR
	ZXBTQp/+3ryCtB6l4gj57gHIIbwi0RoSpZg96Honn4SyRFQEfX
	8N/dvA80Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09.01.2010, 23:38 +0000 Matthew Garrett wrote:
> grep -r . /proc/acpi/video

/proc/acpi/video/GFX0/DD05/EDID:<not supported>
/proc/acpi/video/GFX0/DD05/brightness:<not supported>
/proc/acpi/video/GFX0/DD05/state:state:     0x1d
/proc/acpi/video/GFX0/DD05/state:query:     0x00
/proc/acpi/video/GFX0/DD05/info:device_id:    0x0005
/proc/acpi/video/GFX0/DD05/info:type:         UNKNOWN
/proc/acpi/video/GFX0/DD05/info:known by bios: no
/proc/acpi/video/GFX0/DD04/EDID:<not supported>
/proc/acpi/video/GFX0/DD04/brightness:<not supported>
/proc/acpi/video/GFX0/DD04/state:state:     0x1d
/proc/acpi/video/GFX0/DD04/state:query:     0x00
/proc/acpi/video/GFX0/DD04/info:device_id:    0x0004
/proc/acpi/video/GFX0/DD04/info:type:         UNKNOWN
/proc/acpi/video/GFX0/DD04/info:known by bios: no
/proc/acpi/video/GFX0/DD03/EDID:<not supported>
/proc/acpi/video/GFX0/DD03/brightness:<not supported>
/proc/acpi/video/GFX0/DD03/state:state:     0x1d
/proc/acpi/video/GFX0/DD03/state:query:     0x00
/proc/acpi/video/GFX0/DD03/info:device_id:    0x0003
/proc/acpi/video/GFX0/DD03/info:type:         UNKNOWN
/proc/acpi/video/GFX0/DD03/info:known by bios: no
/proc/acpi/video/GFX0/DD02/EDID:<not supported>
/proc/acpi/video/GFX0/DD02/brightness:levels:  13 25 38 50 63 75 88 100
/proc/acpi/video/GFX0/DD02/brightness:current: 13
/proc/acpi/video/GFX0/DD02/state:state:     0x1f
/proc/acpi/video/GFX0/DD02/state:query:     0x01
/proc/acpi/video/GFX0/DD02/info:device_id:    0x0002
/proc/acpi/video/GFX0/DD02/info:type:         UNKNOWN
/proc/acpi/video/GFX0/DD02/info:known by bios: no
/proc/acpi/video/GFX0/DD01/EDID:<not supported>
/proc/acpi/video/GFX0/DD01/brightness:<not supported>
/proc/acpi/video/GFX0/DD01/state:state:     0x1f
/proc/acpi/video/GFX0/DD01/state:query:     0x01
/proc/acpi/video/GFX0/DD01/info:device_id:    0x0001
/proc/acpi/video/GFX0/DD01/info:type:         UNKNOWN
/proc/acpi/video/GFX0/DD01/info:known by bios: no
/proc/acpi/video/GFX0/DOS:DOS setting: <0>
/proc/acpi/video/GFX0/POST:<not supported>
/proc/acpi/video/GFX0/POST_info:<not supported>
/proc/acpi/video/GFX0/ROM:<TODO>
/proc/acpi/video/GFX0/info:Switching heads:              yes
/proc/acpi/video/GFX0/info:Video ROM:                    no
/proc/acpi/video/GFX0/info:Device to be POSTed on boot:  no


