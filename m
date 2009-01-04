Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbZADXhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbZADXhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZADXhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:37:40 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41562 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZADXhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:37:39 -0500
Message-ID: <49614835.7000505@davidnewall.com>
Date: Mon, 05 Jan 2009 10:07:25 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: david@lang.hm
CC: Kyle Moffett <kyle@moffetthome.net>, Ben Goodger <goodgerster@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>  <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>  <495F0672.6020708@davidnewall.com>  <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>  <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> then new zoneinfo files need to be sent out every time there is a leap
> second (which from other posts on this thread is potentially every month)

Not every few months, for goodness sake!  Leap seconds aren't that
common!  These files do change regularly, however, sometimes on a yearly
basis, because that's how often the date might be changed when daylight
savings transitions.  This is to say that leap seconds don't
particularly change the frequency of zoneinfo updates.

>   if it is something to be fixed in zoneinfo, then complaining to the
> kernel list and demanding that 'Linux be fixed' is not productive.

Updating zoneinfo is trivial.  On the other hand if something has been
done to Linux to support leap seconds (I gather this is the case), then
the point is that it need not have been done, should not have been done,
and needs to be replaced by the standard tools that have worked
satisfactorily for decades, and continue doing so.  So yes, I think it
is productive.
