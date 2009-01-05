Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZAEFsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZAEFsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 00:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZAEFse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 00:48:34 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:26564 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZAEFsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 00:48:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Y7Tnl1nQ2/0/G8fXnQi8raN5kvFwsjoGzGvNyjkAO7Yh4nAz60dgonAnW7DDJCRqVl
         MEDEN4UkmXljD/FCjllscGoGhE/e2yBGNBpPqjw/H47WiROs5iYCcxp2UI/SlZyxW71I
         HjHgeHUC1/3FOBqgLqi7WCQwI9t5ORMpz3WuY=
Message-ID: <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
Date: Sun, 4 Jan 2009 23:48:31 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: david@lang.hm, "Kyle Moffett" <kyle@moffetthome.net>,
       "Ben Goodger" <goodgerster@gmail.com>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <49614835.7000505@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <495F0672.6020708@davidnewall.com>
	 <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>
	 <496076A9.7030907@davidnewall.com>
	 <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
	 <4960897D.5030603@davidnewall.com>
	 <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	 <4961432A.80509@davidnewall.com>
	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	 <49614835.7000505@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/4 David Newall <davidn@davidnewall.com>:
> david@lang.hm wrote:
>> then new zoneinfo files need to be sent out every time there is a leap
>> second (which from other posts on this thread is potentially every month)
>
> Not every few months, for goodness sake!  Leap seconds aren't that
> common!

But they could be.  Appearenly, there was a very long,
multi-year lull, where no leap-seconds were required.
Its not fully understood why, as they used to be common.
Maybe its the melting glaciers :-)

There *was* talk of eliminating them forever (so as to
avoid this kind of bug, which affects banks, satellites,
telecom equipment, etc.) but I guess they didn't do it.

--linas
