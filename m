Return-Path: <linux-kernel-owner+w=401wt.eu-S1763616AbXGFPtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763616AbXGFPtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbXGFPtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:49:25 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:36324 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753564AbXGFPtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:49:25 -0400
Date: Fri, 6 Jul 2007 17:49:23 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andreas Schwab <schwab@suse.de>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Hiroaki Fuse <Hiroaki_Fuse@hq.scei.sony.co.jp>
Subject: Re: Too verbose compat_ioctl messages?
In-Reply-To: <jevecxhep6.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.62.0707061749070.17331@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0707061431360.1203@pademelon.sonytel.be>
 <jevecxhep6.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1704365950-1183736963=:17331"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1704365950-1183736963=:17331
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 6 Jul 2007, Andreas Schwab wrote:
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> writes:
> 
> > Is there anything we can do about this?
> 
> Define it as IGNORE_IOCTL in fs/compat_ioctl.c?

Works fine, thx! I'll submit a patch.

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
---584337861-1704365950-1183736963=:17331--
