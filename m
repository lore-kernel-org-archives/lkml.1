Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbZADXQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbZADXQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZADXQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:16:10 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41551 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZADXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:16:09 -0500
Message-ID: <4961432A.80509@davidnewall.com>
Date: Mon, 05 Jan 2009 09:45:54 +1030
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
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>  <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>  <495F0672.6020708@davidnewall.com>  <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>  <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> so are you saying that other 'correct' OS's have patches issued every
> time a leap second is declared so that they have an in-kernel table of
> them to use to calculate the correct time?

No.  Exactly the contrary.  I'm saying that through use of zoneinfo, for
example, no kernel support is required for leap seconds.  And! this
provides correct results for seconds-between two dates.
