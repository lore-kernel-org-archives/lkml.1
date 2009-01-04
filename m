Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZADXZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZADXZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbZADXZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:25:45 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:47603 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZADXZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:25:44 -0500
Date: Sun, 4 Jan 2009 17:25:34 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Message-ID: <20090104232534.GB1297917@hiwaay.net>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca> <495F0672.6020708@davidnewall.com> <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com> <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4961432A.80509@davidnewall.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, David Newall <davidn@davidnewall.com> said:
> No.  Exactly the contrary.  I'm saying that through use of zoneinfo, for
> example, no kernel support is required for leap seconds.  And! this
> provides correct results for seconds-between two dates.

Again: zoneinfo provides offset from UTC.  Leap seconds are changes in
UTC itself, not time zones, so zoneinfo can't handle that.

Please go read Google, Wikipedia, and NTP lists.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
