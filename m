Return-Path: <linux-kernel-owner+w=401wt.eu-S1161531AbXD2XTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161531AbXD2XTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161542AbXD2XTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:19:12 -0400
Received: from neon.samage.net ([85.17.153.66]:33516 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161531AbXD2XTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:19:11 -0400
Message-ID: <2722.81.207.0.53.1177888737.squirrel@secure.samage.net>
In-Reply-To: <20070429223649.GA12672@linuxtv.org>
References: <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
    <p73d51n1fup.fsf@bingen.suse.de>
    <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
    <20070429173500.GA30248@one.firstfloor.org>
    <alpine.LFD.0.98.0704291040580.9964@woody.linux-f
    <20070429223649.GA12672@linuxtv.org>
Date: Mon, 30 Apr 2007 01:18:57 +0200 (CEST)
Subject: Re: Linux 2.6.21
From: "Indan Zupancic" <indan@nul.nu>
To: "Johannes Stezenbach" <js@linuxtv.org>
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Diego Calleja" <diegocg@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 8b3222cd26cce149ddb9ffa05c4da76e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, April 30, 2007 00:36, Johannes Stezenbach wrote:
> The lesson to learn is that there are some very valid
> reasons why bug reports get ignored (some not mentioned here),
> and there's nothing you can do about it. And it has nothing to
> do with the method or tool used for reporting or tracking.
>
> And I also think that ignoring bad bug reports _increases_
> the software quality, because you can use the saved time
> working on something productive. And it makes developers
> happier :-)
>
> [Just to avoid misunderstandings: By no means do I advocate
> ignoring *every* bug report. But ignoring the bad ones
> is just the sane thing to do.]

I don't know, but what about telling the hapless person who went
through the process of posting a bug what's wrong with the bug report?
Or is software quality the only thing you care about, and you don't
want to waste time on learning people to write better bug reports?

If you want to scare away bug reporters, just ignore their first (and
thus likely bad) bug report they write. There isn't much less motivating
than a deafening silence. Just compare it with writing a patch.

Though, in a sense, if the software quality is measured by the number of
bug reports, your tactic might "improve" it indeed.

That said, if someone is an obvious idiot, ignoring saves time. But I
think that's quite rare, and in general you should give the reporter
feedback, and then ignore the bug report. (Until it improves.)

Greetings,

Indan


