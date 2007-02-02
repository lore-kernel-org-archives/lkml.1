Return-Path: <linux-kernel-owner+w=401wt.eu-S1423008AbXBBEs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423008AbXBBEs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423007AbXBBEs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:48:29 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:48633 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422947AbXBBEs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:48:27 -0500
X-IronPort-AV: i="4.13,271,1167638400"; 
   d="scan'208"; a="108117005:sNHT795797469"
To: Steve Wise <swise@opengridcomputing.com>
Cc: openib-general <openib-general@openib.org>, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: Re: [PATCH 1/10] cxgb3 - main header files]
X-Message-Flag: Warning: May contain useful information
References: <1169216896.15842.6.camel@stevo-desktop>
	<adamz4f0wsy.fsf@cisco.com> <1170363934.16637.58.camel@stevo-desktop>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 01 Feb 2007 20:48:13 -0800
In-Reply-To: <1170363934.16637.58.camel@stevo-desktop> (Steve Wise's message of "Thu, 01 Feb 2007 15:05:34 -0600")
Message-ID: <adazm7x5fn6.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Feb 2007 04:48:14.0343 (UTC) FILETIME=[59235170:01C74685]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Have you had a chance to review this?

Still on my list.

Can we trade?  Can you look at the IPoIB connected mode stuff in the
ipoib-cm branch in

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git

and let me know if you see anything you don't like?

 - R.
