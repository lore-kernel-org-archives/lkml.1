Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbYA1NiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbYA1NiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYA1NiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:38:00 -0500
Received: from aun.it.uu.se ([130.238.12.36]:37319 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbYA1Nh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:37:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18333.55970.74841.660462@harpo.it.uu.se>
Date: Mon, 28 Jan 2008 14:37:38 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Tino Keitel <tino.keitel@gmx.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24 regression: Wake On Lan in sky2 broken on Mac mini
In-Reply-To: <20080128125535.GE32496@elte.hu>
References: <20080128002934.GA6354@dose.home.local>
	<18333.37002.749771.524523@harpo.it.uu.se>
	<20080128125535.GE32496@elte.hu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
 > 
 > * Mikael Pettersson <mikpe@it.uu.se> wrote:
 > 
 > >  > Now I tried the 2.6.24 release and noticed that WOL is still 
 > >  > broken. I'll be happy to test any patches that can make it into 
 > >  > 2.6.24.1.
 > > 
 > > 1. Wrong mailing list; use netdev (@vger) instead.
 > 
 > lkml is the right mailing list for reporting Linux bugs.
 > 
 > this is an extermely harmful trend i've seen lately: some kernel hackers 
 > going out on a limb directing the flow of bugreports _away_ from lkml, 
 > by suggesting to testers that lkml is somehow inappropriate for 
 > reporting Linux kernel bugs.
 > 
 > It's not even the standard "I Cc:-ed netdev, maybe they are interested 
 > in this" message but the above, plain incorrect: "this is the wrong 
 > mailing list" message.
 > 
 > Mikael, what you do is as harmful to Linux as if you were intentionally 
 > putting bugs into the kernel source. In fact it's more harmful because 
 > it is irreversible: bugs you put into Linux i can fix and i can review 
 > all past patches you did to undo the damage - tester attention and 
 > feedback you redirect we cannot direct back.

Ok, I can see how my overly terse statement could be interpreted
in this way, and I apologize for that.

However, it _is_ a fact that there is a proliferation of specialized
mailing lists, and it is also a fact that many developers _only_ read
those lists. I'm in no way defending this behaviour, on the contrary
I probably dislike it as much as you do. But we can't ignore it.

I should of course have written something like "please cc: <whateverlist>"
instead of the stupid "wrong mailing" list comment.

 > Stop it!

Gladly.
