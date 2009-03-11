Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZCKKgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZCKKgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbZCKKgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:36:08 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54677 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754147AbZCKKgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:36:05 -0400
Date: Wed, 11 Mar 2009 11:36:02 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Kyle McMartin <kyle@mcmartin.ca>
cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       linux-m68k@vger.kernel.org, rtc-linux@googlegroups.com,
       linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Paul Mundt <lethal@linux-sh.org>, Dann Frazier <dannf@dannf.org>
Subject: Re: [PATCH 0/7] Generic RTC class driver
In-Reply-To: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Message-ID: <alpine.LRH.2.00.0903111134270.1040@vixen.sonytel.be>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Kyle,

On Mon, 9 Mar 2009, Geert Uytterhoeven wrote:
> These patches are relative to the "rtc-parisc" branch of Kyle's PA-RISC git
> repository, which already contains some cleanups for the rtc-parisc driver by
> Dann, which already have been ack'ed by Alessandro:
> 
> http://git.kernel.org/?p=linux/kernel/git/kyle/parisc-2.6.git;a=shortlog;h=rtc-parisc
> 
> Paul: Feel free to add your SuperH support.
> 
> I suppose the easiest way for this to go in is through Kyle's PA-RISC tree, as
> he already has the preceding patches? Can I have your acks, please?

Is it OK for you to take it through your PA-RISC tree?
If yes, I can resend the patch series with the collected acks.

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
