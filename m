Return-Path: <linux-kernel-owner+w=401wt.eu-S1031061AbXD2S7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031061AbXD2S7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbXD2S7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:59:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbXD2S7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:59:04 -0400
Date: Sun, 29 Apr 2007 11:58:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@stusta.de>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <200704292050.56575.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704291150060.9964@woody.linux-foundation.org>
References: <20070426040806.GJ3468@stusta.de> <200704291849.23197.rjw@sisk.pl>
 <20070429173725.GB30248@one.firstfloor.org>
 <200704292050.56575.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Rafael J. Wysocki wrote:
>
> - You are required to select a category and 'component' for your report, which
>   often is difficult (especially if you're not a kernel expert)
> - You need to have a bugzilla account (or to create one, if you don't)

Amen.

Both of those are show-stoppers. It may be ok for kernel developers, but 
it's not good for random people. It's one of the reasons I don't generally 
use bugzilla for other projects - if they require me to sign up etc, they 
can take care of their own bugs.

(For the same reason I consider closed mailing lists to be useless for 
bugreports. If you have to be a member to send email, it's not a 
bug-report thing, it's just a secret society).

I realize that spam is a problem, but there are better spam solutions than 
alienating the people who just want to send a report.

Also, I don't know if anybody has ever tried to avoid sending duplicate 
bugs, but every time I use bugzilla to send a bug-report (which I do for 
things like FC7 live CD's breaking etc where I care enough, and I have a 
bugzilla account on that bugzilla _anyway_ for other reasons), I am ready 
to _kill_ somebody whenever I see that "humorous" 

	zarro bugs found

message, after it made it almost impossible for me to even figure out how 
to do a good search in the first place!

So I gnash my teeth, and fill in the bug report anyway, and if it's a 
duplicate becasue bugzilla didn't have any sane way to get any kind of 
overview at all, hey, it's a duplicate. Nothing I can do about it.

And the reason I gnash my teeth is that I realize that because I can't 
even get any overview of the bugzilla entries as a random submitter (and 
dammit, I probably have a better idea of what the problem might be than 
most people), I sure as hell can't expect a random user to be better. So I 
bet my bad reports are a lot better than the average, and a lot of people 
probably just give up and don't report anything at all.

		Linus
