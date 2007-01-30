Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbXA3TDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbXA3TDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXA3TC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:02:59 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:10962 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXA3TC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:02:58 -0500
X-IronPort-AV: i="4.13,258,1167638400"; 
   d="scan'208"; a="107074095:sNHT42495120"
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
X-Message-Flag: Warning: May contain useful information
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<45BF8C57.1020500@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Jan 2007 11:02:56 -0800
In-Reply-To: <45BF8C57.1020500@garzik.org> (Jeff Garzik's message of "Tue, 30 Jan 2007 13:20:07 -0500")
Message-ID: <adasldsqqvz.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2007 19:02:57.0023 (UTC) FILETIME=[40C208F0:01C744A1]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The vast majority of these were submitted ages ago.  Standards for
 > acceptance and maintenance have risen since the days of ISA drivers
 > and floppy tape drives.

What are our standards for maintenance?  How can we tell in advance if
something is going to be maintained (cf. drivers/net/chelsio)?

I don't think you can seriously argue that just posting documentation
is going to guarantee that a device is going to get a high-quality
driver that runs on all architectures and that enterprise distros will
support.  And I don't think it's a good strategy to try convince
vendors to open docs by using happy talk about an idealized fantasy world.

 - R.
