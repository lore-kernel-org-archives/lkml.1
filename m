Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYABSe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYABSe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbYABSeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:34:46 -0500
Received: from mail.tmr.com ([64.65.253.246]:34280 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbYABSep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:34:45 -0500
Message-ID: <477BDE0C.8040302@tmr.com>
Date: Wed, 02 Jan 2008 13:55:08 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "The place to get help!" <suspend2-users@lists.tuxonice.net>,
       suspend2-devel@lists.tuxonice.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Freezing filesystems (Was Re: What's in   store for 2008 for
 TuxOnIce?)
References: <477AC060.5040004@nigel.suspend2.net>	<200801020021.37259.rjw@sisk.pl>	<477AD2AA.4070707@nigel.suspend2.net> <20080102010325.GC13288@mit.edu>
In-Reply-To: <20080102010325.GC13288@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Jan 02, 2008 at 10:54:18AM +1100, Nigel Cunningham wrote:
>>> I would also like the TuxOnIce issues related to drivers, ACPI, etc. to go to
>>> one of the kernel-related lists, but I think linux-pm may be better for that
>>> due to the much lower traffic.
>> I guess that makes sense. I guess people can always be referred to LKML
>> for the issues where the appropriate person isn't on linux-pm.
> 
> Hi Nigel,
> 
> I'd really recommend pushing the TuxOnIce discussions to LKML.  That
> way people can see the size of the user community and Andrew and Linus
> can see how many people are using TuxOnIce.  They can also see how
> well the TuxOnIce community helps address user problems, which is a
> big consideration when Linus decides whether or not to merge a
> particular technology. 
> 
> If the goal is eventual merger of TuxOnIce, LKML is really the best
> place to have the discussions.  Examples such as Realtime, CFS, and
> others have shown that you really want to keep the discussion front
> and center.  When one developer says, "not my problem; my code is
> perfect", and the other developer is working with users who report
> problems, guess which technology generally ends up getting merged by
> Linus?
> 
Judging from the fact that TuxOnIce is still excluded, I would say the 
answer is obvious. :-(
Posession is nine points of the law...

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
