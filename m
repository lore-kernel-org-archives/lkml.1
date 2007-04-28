Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbXD1TSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbXD1TSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbXD1TSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:18:16 -0400
Received: from mail.tmr.com ([64.65.253.246]:49318 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbXD1TSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:18:15 -0400
Message-ID: <46339E0C.4070109@tmr.com>
Date: Sat, 28 Apr 2007 15:18:36 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Josh Triplett <josh@kernel.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
   hang in atomic copy)
References: 20070425232806.GL17387@elf.ucw.cz <4630DF19.3060805@kernel.org> <alpine.LFD.0.98.0704261036120.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704261036120.9964@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> (And for me personally, I'd love to have all my machines "sleep" by 
> default, but wake up by eithernet and keyboard - I'd love for my screen 
> saver to literally put the machine to sleep, but not have to worry about 
> touching a keyboard - just ssh'ing into them should still wake up. It's 
> *technically* doable, but it's just a pain to do right now)
> 
And timer somehow so cron jobs could still run. Ideal for critical but 
rarely used machines like fallover servers, the user documentation 
download site, or similar.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
