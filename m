Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbXG1Vzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbXG1Vzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 17:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbXG1Vzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 17:55:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44155 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbXG1Vzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 17:55:39 -0400
Date: Sat, 28 Jul 2007 23:55:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
In-Reply-To: <alpine.LFD.0.999.0707281417201.3442@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707282355010.9488@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost>  <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
 <1185615848.13701.16.camel@localhost> <alpine.LFD.0.999.0707281035390.3442@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707282054330.15125@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0707281222410.3442@woody.linux-foundation.org>
 <alpine.LFD.0.999.0707281417201.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 28 2007 14:33, Linus Torvalds wrote:
>
>Btw, people who actually have 3D games installed (I have exactly one: 
>ppracer, and I can't really say that I care about how it feels), if you 
>don't have CONFIG_HZ=1000, this really is worth testing.
>
>I think Ingo probably ran with CONFIG_NO_HZ and HZ_1000, but the default 
>timer tick is actually 250Hz, which makes all the default scheduler values 
>come out four times bigger than they are documented/supposed to be.

I generally run with CONFIG_HZ=100, CONFIG_NO_HZ=n, CONFIG_PREEMPT_NONE.



	Jan
-- 
