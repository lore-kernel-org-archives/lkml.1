Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbYEDMpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbYEDMpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYEDMpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:45:42 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:50617 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYEDMpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:45:41 -0400
Message-ID: <481DB004.5090109@keyaccess.nl>
Date: Sun, 04 May 2008 14:45:56 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302136.58005.rjw@sisk.pl>	<20080430131537.1f7a0914.akpm@linux-foundation.org>	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>	<20080501003125.GM29330@cs181133002.pp.htv.fi>	<20080430000338.50548884@infradead.org>	<20080501011346.522f9846.akpm@linux-foundation.org> <20080430071526.1bce202c@infradead.org>
In-Reply-To: <20080430071526.1bce202c@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-04-08 16:15, Arjan van de Ven wrote:

> Does that mean nobody should fix the m68k bug? Someone who cares about
> m68k for sure should work on it, or if it's easy for an ext4 developer, 
> sure. But if the ext4 person has to spend 8 hours on it figuring cross
> compilers, I say we're doing something very wrong here. (no offense to
> the m68k people, but there's just a few of you; maybe I should have
> picked voyager instead)

On that note, I'd really like to see better binary availability of cross 
compilers. While it's improved over the last few years mostly due to the 
crossgcc stuff it's still a pain. Ideally, they would be available through 
the distribution package manager even but failing that some dedicated place 
on kernel.org with x86->lots and some of the more widely used other 
combinations would quite definitely be good. Perhaps not really directly 
relevant to this thread as such, but still good.

Andrew maintain{s,ed} a number of them at

http://userweb.kernel.org/~akpm/cross-compilers/

But as you see, most of the stuff there is really old again...

Rene
