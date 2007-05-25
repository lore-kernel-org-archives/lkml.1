Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbXEYF5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbXEYF5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbXEYF5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:57:43 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:27516 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbXEYF5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:57:41 -0400
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 209.50.91.134;Service: EHS
Content-class: urn:content-classes:message
Subject: =?utf-7?B?UkU6ICtBRnMtcGF0Y2grQUYwLSBBZGQgdGhlIGRldmljZSBJRHMgZg==?=
	=?utf-7?B?b3IgQU1EL0FUSSBTQjcwMA==?=
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-7"
Content-Transfer-Encoding: 7bit
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 25 May 2007 13:57:29 +0800
Message-ID: <FFECF24D2A7F6D418B9511AF6F35860201AEFB7F@shacnexch2.atitech.com>
In-Reply-To: <46565134.9040009@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: =?utf-7?B?K0FGcy1wYXRjaCtBRjAtIEFkZCB0aGUgZGV2aWNlIElEcyBmb3IgQQ==?=
	=?utf-7?B?TUQvQVRJIFNCNzAw?=
Thread-Index: AceeeNYeSUg7oWK0TPqBmSRNnWODMgAFy8Rw
From: "Henry Su" <henry.su@amd.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: <alan@lxorguk.ukuu.org.uk>, <greg@kroah.com>, <bzolnier@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       <xiaosuzi520@hotmail.com>
X-OriginalArrivalTime: 25 May 2007 05:57:33.0853 (UTC) FILETIME=[96AA2CD0:01C79E91]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Jeff,
Thanks for your kindly help, I will fix the email next time.
Do you mean all the device IDs for ATI SB700 are added to the corresponding files?
because I split this patch and resent four patches according to your last suggestion,
if this patch is applied, another patches are  not necessary now.

Thanks
Henry

-----Original Message-----
From: Jeff Garzik +AFs-mailto:jeff+AEA-garzik.org+AF0- 
Sent: Friday, May 25, 2007 11:00 AM
To: Henry Su
Cc: alan+AEA-lxorguk.ukuu.org.uk+ADs- greg+AEA-kroah.com+ADs- bzolnier+AEA-gmail.com+ADs- linux-kernel+AEA-vger.kernel.org+ADs- linux-ide+AEA-vger.kernel.org+ADs- xiaosuzi520+AEA-hotmail.com
Subject: Re: +AFs-patch+AF0- Add the device IDs for AMD/ATI SB700

Henry Su wrote:
+AD4- --- linux-2.6.21.1.orig/drivers/ata/pata+AF8-atiixp.c	2007-05-10 06:30:14.000000000 +080-
+AD4-  linux-2.6.21.1/drivers/ata/pata+AF8-atiixp.c	2007-05-10 07:17:07.000000000 +080-
+AD4- +AEAAQA- -283,6 +280-,7 +AEAAQA- static const struct pci+AF8-device+AF8-id atiixp
+AD4-  	+AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP300+AF8-IDE), +AH0-,
+AD4-  	+AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP400+AF8-IDE), +AH0-,
+AD4-  	+AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-IDE), +AH0-,
+AD4- 	+AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-IDE), +AH0-,


Patch applied manually.

Your patches are all technically correct -- but you really need to fix
your email so that we can receive and apply your patches via scripts.

This is a basic step that every kernel contributor needs to take.

	Jeff





