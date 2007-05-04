Return-Path: <linux-kernel-owner+w=401wt.eu-S1031504AbXEDSSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031504AbXEDSSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031498AbXEDSSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:18:36 -0400
Received: from dvhart.com ([64.146.134.43]:52637 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031504AbXEDSSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:18:34 -0400
Message-ID: <463B78F5.4090809@mbligh.org>
Date: Fri, 04 May 2007 11:18:29 -0700
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bugzilla (was Linux 2.6.21)
References: <20070426040806.GJ3468@stusta.de> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <200704292050.56575.rjw@sisk.pl> <20070429191432.GA31445@one.firstfloor.org>
In-Reply-To: <20070429191432.GA31445@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, have been out sick, and someone removed me from the cc list,
which didn't help. In response to various bits:

Firstly a general comment - we're about to upgrade versions, which
will ease a few of these issues. I should really finish the creation
of virtual category owners for *all* categories. Will see if we can
batch that, as it's a total pain to do.

Andi Kleen wrote:
 > - Ask more people to just categorize and reassign bugs (anybody
 > interested?)

The category owners should be able to do that, and help spread the
load. The virtual category owner stuff enables many people to "watch"
new bugs for that category and help out.

 > - Give more people in bugzilla the power to reassign arbitary bugs
 > (bugzilla maintainers would need to do that)

Fairly easy to do, just a permissions issue. Either I can add a bunch
of "known" people, or let everyone do it and then slap people if
they're silly about it.

>> - You are required to select a category and 'component' for your report, which
>> often is difficult (especially if you're not a kernel expert)
> 
> Usually there is other and then someone else figures it out.

I can make that clearer in the form if it helps.

> The Novell bugzilla actually has that fixed. You have a search email button
> to look up addresses.  Perhaps that feature will be ported someday into
> the kernel.org one (I would like to have it too) 

I *think* that's in the new version. Will check.

> The only sane way to do that would be to save them somewhere and keep
> a list and then let a group of people process them.
> 
> Hmm, wait... sounds like bugzilla, doesn't it?

Yes, though we could do with some improved email hooks still, I guess.
I much prefer having people watch categories than spamming lists, but
if people want lists spammed, we can have that.


