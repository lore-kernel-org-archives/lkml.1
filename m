Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbXFOMLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbXFOMLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbXFOMLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:11:24 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49678 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753835AbXFOMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:11:23 -0400
Message-Id: <20070615113919.142332000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Fri, 15 Jun 2007 13:39:19 +0200
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org
Subject: [patch 0/6] PS3 Storage Drivers for 2.6.23, take 2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi,

This is the second submission of the new PS3 storage drivers:
  [1] ps3: Preallocate bootmem memory for the PS3 FLASH ROM storage driver
  [2] ps3: Storage Driver Core
  [3] ps3: Storage device registration routines.
  [4] ps3: Disk Storage Driver
  [5] ps3: ROM Storage Driver
  [6] ps3: FLASH ROM Storage Driver

They are based on the current Linux kernel source tree, plus the PS3 patches
already submitted by Geoff Levand on linuxppc-dev.

All issues raised during the previous review round should be fixed.

If there are no more comments, please apply for 2.6.23.  Since they depend on
other PS3 work, I think it's most logical to let Paul integrate them.

Thanks in advance!

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619

