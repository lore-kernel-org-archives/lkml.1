Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbZAHPFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbZAHPFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZAHPFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:05:31 -0500
Received: from bsdimp.com ([199.45.160.85]:54460 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758897AbZAHPF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:05:29 -0500
Date: Thu, 08 Jan 2009 08:02:29 -0700 (MST)
Message-Id: <20090108.080229.1159156694.imp@bsdimp.com>
To: alan@lxorguk.ukuu.org.uk
Cc: mayer@ntp.isc.org, linasvepstas@gmail.com, david@lang.hm, hancockr@shaw.ca,
       kyle@moffetthome.net, slashdot@jameshallam.info, goodgerster@gmail.com,
       davidn@davidnewall.com, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, nick@nick-andrew.net, jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <20090108104854.2dbc41b1@lxorguk.ukuu.org.uk>
References: <496579C2.5050800@ntp.isc.org>
	<20090107.214220.-233694826.imp@bsdimp.com>
	<20090108104854.2dbc41b1@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 5.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <20090108104854.2dbc41b1@lxorguk.ukuu.org.uk>
            Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
: > On FreeBSD, Solaris and Digital Unix, I'll point out, that jumping
: > backwards is used, and has been used since at least 1994.  So saying
: > it isn't used in the world today is flat out wrong.
: 
: I stand by my comment - when was the last time the IERS used a leap
: second removal ? The code may exist but it doesn't happen.

Jumping backwards is used for every leap second that IERS has ever
done, which was your original comment.  There's has never been a case
where there was a leap second for jump forward though.  The proper
technical term here is 'negative leap second'.  All leap seconds up
until now have been positive leap seconds, and it is unlikely there
ever will be a negative one.

Warner
