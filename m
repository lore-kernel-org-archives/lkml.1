Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYKMUsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYKMUsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYKMUsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:48:40 -0500
Received: from c60.cesmail.net ([216.154.195.49]:63627 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYKMUsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:48:39 -0500
Subject: Re: [madwifi-project] [RFC] Closing the project
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Renzmann <mrenzmann@madwifi-project.org>,
       madwifi-project@venema.h4ckr.net,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <43e72e890811131142p3f72c964t802d424b0ddb3456@mail.gmail.com>
References: <2576.194.45.26.221.1226491274.squirrel@webmail.madwifi.org>
	 <1226511194.9952.38.camel@dv>
	 <43e72e890811121224w4fc53e1s29080a42111186e9@mail.gmail.com>
	 <1226547092.11785.49.camel@dv>
	 <43e72e890811131142p3f72c964t802d424b0ddb3456@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 13 Nov 2008 15:48:36 -0500
Message-Id: <1226609316.2904.18.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 11:42 -0800, Luis R. Rodriguez wrote:

> We will be working on DFS on mac80211, I will start first with STA
> DFS. Also expect a lot of work from us on AP support.

That's great news!

> >> I think MadWifi has become a big bureaucratic entity and this large
> >> bureaucracy is simply not needed.
> >
> > I agree that we have a lot of documentation that is becoming irrelevant.
> > I prefer to keep documentation to the minimum, as it stimulates
> > developers to write software that just works, without lengthy
> > instructions.
> >
> > But the bug tracking system has some important information that we still
> > may need.
> >
> > I think the biggest impediment to MadWifi development was not
> > bureaucracy.  It was the non-free HAL.
> 
> Not really, even with an alternative people are still used to coding
> with it and find it easier to commit into an svn repository than
> submit  patches upstream. Maybe our process is move involved but there
> its also why Linux code has a certain quality in it. We tend to frown
> upon crap. If MadWifi ever were to touch Linux it would be tainted
> with CRAP.

OK, HAL was not the only reason.  Let's say there is good bureaucracy
and bad bureaucracy.  The difference is the former is helpful and the
later is not.  The kernel is an excellent example of good bureaucracy
that we should learn from.

It would be great to have a detailed analysis why MadWifi failed.  It
would be useful for other projects.  I'm short on time to do it right
now, but I may do it later.

I think we should have done more to prevent incomplete or broken changes
from being committed.  The reason I cannot backport SMP fixes is because
they were committed as series of commits that involved other issues as
well.  Such sloppiness should have been prevented.

> Just my advice: let MadWifi die already, stop wasting your time.

I understand what you mean, but I have to deal with MadWifi anyway.  As
I said before, I'd rather share my fixes that keep them to myself.

-- 
Regards,
Pavel Roskin
