Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbXGJHpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbXGJHpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXGJHpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:45:20 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35048 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757064AbXGJHpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:45:18 -0400
Date: Tue, 10 Jul 2007 09:45:15 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [patch 0/6] PS3 Storage Drivers for 2.6.23, take 4
In-Reply-To: <20070704132212.726923000@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0707100944470.22782@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-353563100-1184053515=:22782"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-353563100-1184053515=:22782
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 4 Jul 2007, Geert Uytterhoeven wrote:
> This is the fourth submission of the new PS3 storage drivers:
>   [1] ps3: Preallocate bootmem memory for the PS3 FLASH ROM storage driver
>   [2] ps3: Storage Driver Core
>   [3] ps3: Storage device registration routines.
>   [4] ps3: Disk Storage Driver
>   [5] ps3: BD/DVD/CD-ROM Storage Driver
>   [6] ps3: FLASH ROM Storage Driver
> 
> They are based on:
>   - the current Linux kernel source tree,
>   - plus the PS3 patches already submitted by Geoff Levand on linuxppc-dev,
>   - plus the shost_priv() patch in scsi-misc (commit
>     bcd92c9fbcc679ee95003083056f0441a1f474fa).
> 
> All issues raised during the previous review rounds should be fixed.
> There were no more comments after the third submission.
> 
> Paul already integrated Geoff Levand's PS3 patches and the first 3 patches
> in this series in the for-2.6.23 branch in powerpc.git.
> 
> Maintainers of block/SCSI/misc, can you please ack the last 3 patches so Paul
> can take them, too?

Ping block/SCSI/misc maintainers?

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
---584337861-353563100-1184053515=:22782--
