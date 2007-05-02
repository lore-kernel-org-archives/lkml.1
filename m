Return-Path: <linux-kernel-owner+w=401wt.eu-S2993006AbXEBKey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993006AbXEBKey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993026AbXEBKey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:34:54 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:34131 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993006AbXEBKex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:34:53 -0400
Message-ID: <46386917.10704@s5r6.in-berlin.de>
Date: Wed, 02 May 2007 12:33:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>, Valdis.Kletnieks@vt.edu,
       Andre Tomt <andre@tomt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: so ... what *are* candidates for removal?
References: <Pine.LNX.4.64.0705011050080.11853@localhost.localdomain>            <46375D1C.4050404@tomt.net> <10590.1178037443@turing-police.cc.vt.edu> <4637C04E.4070306@s5r6.in-berlin.de> <Pine.LNX.4.64.0705020418530.7102@localhost.localdomain> <46385EF8.8040005@s5r6.in-berlin.de> <alpine.DEB.0.98.0705020612290.9993@sigma.j-a-k-j.com>
In-Reply-To: <alpine.DEB.0.98.0705020612290.9993@sigma.j-a-k-j.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Anthony Kazos Jr. wrote:
[I wrote]
>> BTW, of course it doesn't suffice to say "we can't remove it yet" after
>> the due day.  There need to be well-founded reasons for another
>> deferral.
[...]
> So when this sort of thing comes up, why can't somebody put together a 
> trivial patch to update feature-removal-schedule.txt? If a deadline is 
> reached, and a removal is attempted and aborted, the deadline should be 
> extended, obviously. So then the patches can be resubmitted (or recreated, 
> even) when the new deadline is reached, da capo.

<stating_the_obvious>
Yes, of course.  When a decision is reached to defer or even abort a
feature removal process, the maintainer in charge should take care that
such an updating patch goes to feature-removal-schedule.txt.

So if there are outdated entries in feature-removal-schedule.txt, then
it's because someone forgot something, and it won't hurt to ask the
responsible person if he knows of a change in the removal plan.
</stating_the_obvious>
-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/
