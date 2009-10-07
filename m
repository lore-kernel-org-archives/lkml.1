Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbZJGPjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbZJGPjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbZJGPje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:39:34 -0400
Received: from fifo99.com ([67.223.236.141]:35782 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759471AbZJGPjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:39:33 -0400
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
From: Daniel Walker <dwalker@fifo99.com>
To: rostedt@goodmis.org
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Andy Whitcroft <apw@canonical.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1254928114.1696.164.camel@gandalf.stny.rr.com>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	 <1254406711.18167.88.camel@desktop> <m33a5ww8kn.fsf@intrepid.localdomain>
	 <1254887534.18167.253.camel@desktop>  <m3hbubv779.fsf@intrepid.localdomain>
	 <1254925617.18167.262.camel@desktop>
	 <1254928114.1696.164.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 08:38:27 -0700
Message-Id: <1254929907.18167.301.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 11:08 -0400, Steven Rostedt wrote:
> Daniel,
> 
> This is getting old. You've successfully entered the /dev/null folder to
> several major developers.

Getting into a /dev/null folder for code comments is just absolutely
insane to me. Any one that puts me into /dev/null has some pretty low
tolerances ..

What's getting old exactly ? The fact that Krzysztof and I are having a
discussion about this?

> The checkpatch.pl script is a very useful tool. I run it on all my
> patches to make sure that I don't have any silly formatting errors. It
> even catches some real bugs now and then.
> 
> That said, if we really wanted to have checkpatch as a authoritative
> tool, it would be executed by a bot on all patches submitted to LKML
> (which you seem to have put on yourself to do). But if Linus or others
> wanted that, they would have set it up.

You have a much different impression of this list than I do.. From my
perspective this list is made up of 1000's of people each having their
own agenda.. I have an agenda , you have one, everyone has one of their
own.. By saying "if Linus or others wanted that, they would have set it
up." . Your basically saying that only some "cool" people can have
specific agenda's and some (me) can't have agenda's , which to me is
totally bogus and wrong..

You had your chance to comments on my activity already, and did I take
your advice or anyones advice from this list? Do you see lots of emails
from me on checkpatch errors constantly??

> We assume that the maintainers of the system are competent enough to
> keep a decent formatting style that conforms to the rest of the kernel.
> There are some instances that the style may change to cover cases that
> are unique, like the events headers.

I don't totally disagree with that, however as I'm telling Krzysztof
even maintainers should have a good reason why they are deviating from
it.

> Really it should be up to the maintainer to tell a submitter that they
> need to run checkpatch. You are coming out as the checkpatch Nazi leader
> to "enforce" your will of the tool on others. And when they tell you,
> it's not that big of a deal, you have a conniption.

conniption? I hope your joking.. I argue sure, which is my right to do..
Clearly I can't force people to do anything, like I can't force you to
change your events header files. I gave you an alternative, you didn't
use it, and there is nothing else I can do about it..

> So my advice to you is to take a chill pill (they come in chewables) and
> relax a bit on this topic. If you had just sent out some nice emails to
> obvious breakage in patches, then it would have been fine. But you are
> coming across a bit too authoritarian, and it is becoming quite
> annoying.

Well there is a potentially easy way for you to stop me.. All you have
to do is write a patch that modifies Documentation/SubmittingPatches .
I'm not trying to bluff you at all, I fully expect you to submit a patch
that changes that .. If it goes in then that's what I will follow. 

You'll notice also I'm not sending many emails recently on this subject
right? It's like you want to harp on this more than I do ..

Just relax the submission rules so that checkpatch is basically an
optional part of the submission process. Adding that you don't actually
need to run it, you don't need a good reason not to follow the rules
etc.. Or expand on it to fully explain what you think the deal is or
should be.

Daniel

