Return-Path: <linux-kernel-owner+w=401wt.eu-S1761205AbYDTUgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761205AbYDTUgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbYDTUgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:36:21 -0400
Received: from lazybastard.de ([212.112.238.170]:39937 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbYDTUgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:36:20 -0400
Date: Sun, 20 Apr 2008 22:35:54 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420203554.GE20694@logfs.org>
References: <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca> <20080420133857.GB26536@1wt.eu> <480B50F1.8040309@firstfloor.org> <20080420164133.GB20694@logfs.org> <480B7B1E.7010707@firstfloor.org> <20080420174249.GC20694@logfs.org> <480B8932.1090308@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <480B8932.1090308@firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 April 2008 20:19:30 +0200, Andi Kleen wrote:
> 
> Sure but I don't think they're x86 embedded people. Right now there
> are very little x86 SOCs if any (iirc there is only some obscure rise
> core) and future SOCs will likely have more RAM.
> 
> Anyways I don't have a problem to give these people any special options
> they need to do whatever they want.  I just object to changing the
> default options on important architectures to force people in completely
> different setups to do part of their testing.

Ah, ok.  The question whether 4k stacks should become the default I
prefer not touching with an 80' pole.

Jörn

-- 
Why do musicians compose symphonies and poets write poems?
They do it because life wouldn't have any meaning for them if they didn't.
That's why I draw cartoons.  It's my life.
-- Charles Shultz
