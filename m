Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXJXJia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXJXJia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXJXJiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:38:23 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58541 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751237AbXJXJiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:38:22 -0400
Date: Wed, 24 Oct 2007 11:38:21 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Greg KH <gregkh@suse.de>
cc: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git12: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
In-Reply-To: <20071018160829.GE13346@suse.de>
Message-ID: <Pine.LNX.4.62.0710241138050.31837@pademelon.sonytel.be>
References: <4716F134.2060002@rtr.ca> <20071018160829.GE13346@suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1939898777-1193218701=:31837"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1939898777-1193218701=:31837
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 18 Oct 2007, Greg KH wrote:
> On Thu, Oct 18, 2007 at 01:37:56AM -0400, Mark Lord wrote:
> > usb 5-1: new high speed USB device using ehci_hcd and address 2
> > usb 5-1: configuration #1 chosen from 1 choice
> > hub 5-1:1.0: USB hub found
> > hub 5-1:1.0: 4 ports detected
> > sysfs: duplicate filename 'bInterfaceNumber' can not be created
> 
> Known issue, people are working on it, there's already a proposed patch
> on lkml for this.

But it's not in 2.6.24-rc1, right?

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
---584337861-1939898777-1193218701=:31837--
