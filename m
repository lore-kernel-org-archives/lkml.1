Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZCKR00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZCKR00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZCKR0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:26:16 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:64022 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752604AbZCKR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:26:15 -0400
Date: Wed, 11 Mar 2009 18:26:12 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Kyle McMartin <kyle@infradead.org>
cc: Kyle McMartin <kyle@mcmartin.ca>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       linux-m68k@vger.kernel.org, rtc-linux@googlegroups.com,
       linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Paul Mundt <lethal@linux-sh.org>, Dann Frazier <dannf@dannf.org>
Subject: Re: [PATCH 0/7] Generic RTC class driver
In-Reply-To: <20090311154505.GB5448@bombadil.infradead.org>
Message-ID: <alpine.LRH.2.00.0903111825040.1040@vixen.sonytel.be>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <alpine.LRH.2.00.0903111134270.1040@vixen.sonytel.be> <20090311154505.GB5448@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Kyle,

On Wed, 11 Mar 2009, Kyle McMartin wrote:
> On Wed, Mar 11, 2009 at 11:36:02AM +0100, Geert Uytterhoeven wrote:
> > Is it OK for you to take it through your PA-RISC tree?
> > If yes, I can resend the patch series with the collected acks.
> 
> That's fine with me, just hit me up with a git tree address and I'll
> suck it all into the rtc-parisc tree?

I put it up at:

master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-rtc-generic.git

The master branch should be a descendant of your rtc-parisc branch.

Thanks!

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
