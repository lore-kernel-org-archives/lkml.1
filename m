Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZAFScQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZAFScQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZAFScA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:32:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43740 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750947AbZAFSb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:31:59 -0500
Date: Tue, 6 Jan 2009 09:40:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Andrew <nick@nick-andrew.net>
Cc: David Newall <davidn@davidnewall.com>,
       Linas Vepstas <linasvepstas@gmail.com>, david@lang.hm,
       Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
Message-ID: <20090106094058.64c89586@lxorguk.ukuu.org.uk>
In-Reply-To: <20090106025125.GB28431@mail.local.tull.net>
References: <496076A9.7030907@davidnewall.com>
	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
	<4960897D.5030603@davidnewall.com>
	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	<4961432A.80509@davidnewall.com>
	<alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	<49614835.7000505@davidnewall.com>
	<3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	<20090105143335.GC18055@mail.local.tull.net>
	<4962BB13.7060304@davidnewall.com>
	<20090106025125.GB28431@mail.local.tull.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>        UTC  equivalent  to  conversion  on  the naive basis that leap seconds are ignored and all
>        years divisible by 4 are leap years.  This value is not the same as the actual  number  of
>        seconds between the time and the Epoch, because of leap seconds and because clocks are not
>        required to be synchronized to a standard reference.

I'm not sure what you are quoting from but it is out of date on the
subject of leap years.

The rest looks right.
