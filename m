Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZC0Ox7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZC0Ox7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZC0Oxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:53:51 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:48328 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752305AbZC0Oxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:53:50 -0400
Date: Fri, 27 Mar 2009 15:53:47 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Hans-Peter Jansen <hpj@urpla.net>
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <200903271435.23116.hpj@urpla.net>
Message-ID: <alpine.LRH.2.00.0903271552080.11064@vixen.sonytel.be>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <200903271435.23116.hpj@urpla.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, Hans-Peter Jansen wrote:
> Am Dienstag, 24. März 2009 schrieb Linus Torvalds:
> > This obviously starts the merge window for 2.6.30, although as usual,
> > I'll probably wait a day or two before I start actively merging.
> 
> It would be very nice, if you could start with a commit to Makefile, that 
> reflects the new series: e.g.:
> 
> VERSION = 2
> PATCHLEVEL = 6
> SUBLEVEL = 30
> EXTRAVERSION = -pre
> 
> -pre for preparing state.

If you're using the kernel-of-they-day, you're probably using git, and
CONFIG_LOCALVERSION_AUTO=y should be mandatory.

My kernel is called 2.6.29-03321-gbe0ea69...

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
