Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbXJFTrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbXJFTrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 15:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbXJFTrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 15:47:10 -0400
Received: from mail.tmr.com ([64.65.253.246]:41038 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXJFTrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 15:47:09 -0400
Message-ID: <4707E7C9.8010501@tmr.com>
Date: Sat, 06 Oct 2007 15:53:45 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Colored kernel message output
> 
> Let's work more on Linux's cuteness! [http://lkml.org/lkml/2007/10/4/431]
> The following patch makes it possible to give kernel messages a
> selectable color which helps to distinguish it from other noise,
> such as boot messages. NetBSD has it, OpenBSD has it, FreeBSD to some
> extent, so I think Linux should too.
> 
> Inspired by cko (http://freshmeat.net/p/cko/), but independently
> written, later contributed forth and back.
> 
I like it, although having a boot option would be nice (I have a friend 
with color perception issues).

I start my root xterm in white on blue for identification, so color 
coding sounds like a great idea to me.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
