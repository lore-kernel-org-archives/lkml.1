Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXA3WPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXA3WPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXA3WPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:15:40 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:29264 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXA3WPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:15:39 -0500
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="107120082:sNHT67935276"
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	<45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
	<45BFC1DA.7040807@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 14:15:32 -0800
In-Reply-To: <45BFC1DA.7040807@garzik.org> (Jeff Garzik's message of "Tue, 30 Jan 2007 17:08:26 -0500")
Message-ID: <adamz40p3ej.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 22:15:33.0117 (UTC) FILETIME=[28BA0AD0:01C744BC]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > OK, fair enough, I forgot about tg3.  But on the other hand, you
 > > wrote
 > > it without docs, actually _in spite of_ Broadcom, right?
 > > Which I think makes my point that documentation is neither necessary
 > > nor sufficient for a good Linux driver.  Documentation helps, but if
 > > no one competent cares about the device then the driver won't get
 > > written.  On the other hand, if the device is important enough, the
 > > driver will get written without documentation or vendor support.
 > 
 > That's your point??  I thought your point was (quoting your words)
 > 
 > > it's a
 > > bit disingenous to suggest that all a company has to do to get a
 > > driver written and supported is throw some documentation over the
 > > wall.  And it's crazy to suggest that the driver will work on every
 > > platform and be supported by enterprise distros.
 > 
 > To repeat -- that's how most Linux drivers have been written,
 > /particularly/ the ones used most by users of enterprise distros.

I thought you wrote tg3 without docs and without help from Broadcom?

To repeat, my point is that the drivers used most by users of
enterprise distros will get written with or without vendor docs or
help.  Drivers for hardware that only a few people care about probably
won't be written and definitely won't be maintained by volunteers even
if the vendor publishes docs.  And I think that's pretty much what I
said in both of the paragraphs you quoted above.

 - R.
