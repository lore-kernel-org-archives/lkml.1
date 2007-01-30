Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbXA3WAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbXA3WAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXA3WAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:00:44 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:46895 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXA3WAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:00:43 -0500
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="107114105:sNHT67386456"
To: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	<45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
	<20070130214759.GA12477@kroah.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 14:00:24 -0800
In-Reply-To: <20070130214759.GA12477@kroah.com> (Greg KH's message of "Tue, 30 Jan 2007 13:47:59 -0800")
Message-ID: <adar6tcp43r.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 22:00:26.0304 (UTC) FILETIME=[0C395C00:01C744BA]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The Ralink wireless drivers are working to get their stuff upstream.  I
 > think there is only some wireless infrastructure needed to complete
 > before it gets into mainline, but you will have to ask them about this.
 > 
 > There was a wireless-mini-summit a week or so ago, so those developers
 > all know what is going on in that space right now.  They are facing a
 > number of different regulatory issues, combined with lack of
 > specifications from some vendors.  I don't think that the developers who
 > actually have specs are complaining about anything right now.

OK, one last reply before I give up on this thread...

Sure, Ralink drivers will get upstream eventually.  But by the time
the drivers get merged, Ralink will have stopped making the chips that
it supports (or so I read, http://www.linuxemporium.co.uk/products/wireless/)!
I don't think that taking a year or two to merge a driver is going to
impress a vendor, especially since the reverse-engineered Broadcom
wireless driver is probably going to go upstream at just about the
same time.

An uncharitable vendor might decide it's not worth publishing specs,
since the Linux guys can reverse engineer the Windows driver just as
fast anyway.

 - R.
