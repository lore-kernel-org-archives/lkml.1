Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbXA3WTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbXA3WTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbXA3WT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:19:29 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:21551 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbXA3WT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:19:26 -0500
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="761088689:sNHT42930168"
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	<45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
	<20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com>
	<45BFC2CF.8010603@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 14:19:24 -0800
In-Reply-To: <45BFC2CF.8010603@garzik.org> (Jeff Garzik's message of "Tue, 30 Jan 2007 17:12:31 -0500")
Message-ID: <adaireop383.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 22:19:24.0999 (UTC) FILETIME=[B2F06D70:01C744BC]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > You mean the bcm43xx wireless driver that's been upstream for months?

Sorry, yes.  For some reason I thought it was blocked on the dscape
merge but obviously I was wrong.  So a reverse-engineered driver got
upstream WAY FASTER than a driver where the vendor published specs and
GPLed source.

Why did that happen?  I would argue that it was because way more
people cared about the broadcom driver (since the chip was in apple
laptops and the wrt54g among other things).  That developer and user
interest is more important than the info provided by the vendor.

Anyway, I broke my first promise to drop this thread, but I'll make
the promise again now...

 - R.
