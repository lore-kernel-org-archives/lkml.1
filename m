Return-Path: <linux-kernel-owner+w=401wt.eu-S1751803AbZAEAog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbZAEAog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZAEAo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:44:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54691 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751973AbZAEAo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:44:26 -0500
Date: Mon, 5 Jan 2009 00:44:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: David Newall <davidn@davidnewall.com>, Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, linasvepstas@gmail.com,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
Message-ID: <20090105004405.2607b506@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0901041702540.25545@asgard.lang.hm>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	<20090102210430.49649261@diego-desktop>
	<495E7849.4030706@shaw.ca>
	<495F0672.6020708@davidnewall.com>
	<8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>
	<496076A9.7030907@davidnewall.com>
	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
	<4960897D.5030603@davidnewall.com>
	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	<4961432A.80509@davidnewall.com>
	<alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	<49614835.7000505@davidnewall.com>
	<alpine.DEB.1.10.0901041702540.25545@asgard.lang.hm>
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

> another poster said that NTP packets include information about this 
> month's leap second, so that implies that they could change monthly.

The current rules don't permit this but any rule could be change. However
its unlikely. Current the earth rotation people do this twice a year if
neccessary. It is also too complex to predict significantly (ie years) in
advance when it will be neccessary because the complexity of the tidal
forces involved is beyond simulation.
