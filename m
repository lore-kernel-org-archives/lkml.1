Return-Path: <linux-kernel-owner+w=401wt.eu-S1763887AbXGPNAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763887AbXGPNAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbXGPNAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:00:38 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2701 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbXGPNAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:00:37 -0400
Date: Mon, 16 Jul 2007 15:00:57 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
In-Reply-To: <20070716121906.GA18169@elte.hu>
Message-ID: <Pine.LNX.4.64.0707161444510.1817@scrub.home>
References: <19044.1184539364@lwn.net> <Pine.LNX.4.64.0707161325040.1818@scrub.home>
 <20070716114734.GA12010@elte.hu> <Pine.LNX.4.64.0707161353350.1818@scrub.home>
 <20070716115744.GA14131@elte.hu> <Pine.LNX.4.64.0707161404240.1817@scrub.home>
 <20070716121906.GA18169@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Ingo Molnar wrote:

> > Well, you cut out the major question from my initial mail:
> > One question here would be, is it really a problem to sleep a little more?
> 
> oh, i did not want to embarrass you (and distract the discussion) with 
> answering a pretty stupid, irrelevant question that has the obvious 
> answer even for the most casual observer: "yes, of course it really is a 
> problem to sleep a little more, read the description of the fine patch 
> you are replying to" ...

And your insults continue... :-(
I ask a simple question and try to explore alternative solutions and this 
is your contribution to it?

To put this into a little more context, this is the complete text you cut 
off:

| One question here would be, is it really a problem to sleep a little more?
| Another possibility would be to add another sleep function, which uses 
| hrtimer and could also take ktime argument.

So instead of considering this suggestion, you just read what you want out 
of what I wrote and turn everything into an insult. Nicely done, Ingo. :-(

bye, Roman
