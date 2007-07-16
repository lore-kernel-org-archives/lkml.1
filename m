Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbXGPMFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbXGPMFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbXGPMFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:05:39 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4239 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbXGPMFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:05:38 -0400
Date: Mon, 16 Jul 2007 14:05:56 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
In-Reply-To: <20070716115744.GA14131@elte.hu>
Message-ID: <Pine.LNX.4.64.0707161404240.1817@scrub.home>
References: <19044.1184539364@lwn.net> <Pine.LNX.4.64.0707161325040.1818@scrub.home>
 <20070716114734.GA12010@elte.hu> <Pine.LNX.4.64.0707161353350.1818@scrub.home>
 <20070716115744.GA14131@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Ingo Molnar wrote:

> i'm not sure how your question relates/connects to what i wrote above, 
> could you please re-phrase your question into a bit more verbose form so 
> that i can answer it? Thanks,

Well, you cut out the major question from my initial mail:
One question here would be, is it really a problem to sleep a little more?

bye, Roman
