Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYBKKgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYBKKgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYBKKgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:36:42 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:50150 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752119AbYBKKgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:36:41 -0500
Date: Mon, 11 Feb 2008 11:36:39 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de
Subject: Re: [PATCH] Fix compilation of powerpc asm-offsets.c with old gcc
In-Reply-To: <1202495464.6722.13.camel@odie.local>
Message-ID: <Pine.LNX.4.64.0802111134310.8544@vixen.sonytel.be>
References: <18347.34100.60973.215093@cargo.ozlabs.ibm.com>
 <alpine.LFD.1.00.0802071449240.2896@woody.linux-foundation.org>
 <20080208120623.3ad74e3a.pj@sgi.com> <1202495464.6722.13.camel@odie.local>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-491899868-1202726199=:8544"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-491899868-1202726199=:8544
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 8 Feb 2008, Simon Holm Th鴊ersen wrote:
> fre, 08 02 2008 kl. 12:06 -0600, skrev Paul Jackson:
> > Linus wrote:
> > > Please, when mentioning hex numbers, also do the one-liner shortlog.
> > > ...
> > > without _requiring_ people to be git users to get the gist of the 
> > > matter, ok?
> > 
> > 
> > Thanks for sticking up for us git-challenged contributors.
> > 
> > Can anyone point me at instructions providing the shortest
> > path for getting from one of those git hex numbers to the
> > log or change it represents, for non-git users?
> 
> Use gitweb [1], Linus' tree is here [2]. Just search for the hex.
> 
> [1] http://git.kernel.org/
> [2]
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary

As the IDs are supposed to be unique, it doesn't matter where you look it up,
as long as the tree has that commit ;-)

BTW, time for Google to start handling git IDs?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village 路 Da Vincilaan 7-D1 路 B-1935 Zaventem 路 Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 路 B-1840 Londerzeel 路 Belgium
VAT BE 0413.825.160 路 RPR Brussels
Fortis Bank Zaventem 路 Swift GEBABEBB08A 路 IBAN BE39001382358619
---584349381-491899868-1202726199=:8544--
