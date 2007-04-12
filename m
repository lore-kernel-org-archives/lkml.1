Return-Path: <linux-kernel-owner+w=401wt.eu-S2992576AbXDLPYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992576AbXDLPYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992573AbXDLPYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:24:12 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:30914 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992570AbXDLPYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:24:10 -0400
X-IronPort-AV: i="4.14,403,1170662400"; 
   d="scan'208"; a="135025357:sNHT759994317"
To: Divy Le Ray <divy@chelsio.com>
Cc: Steve Wise <swise@opengridcomputing.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Netdev@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2.6.21] iw_cxgb3 - Add set_tcb_rpl_handler.
X-Message-Flag: Warning: May contain useful information
References: <1176382594.9396.1.camel@stevo-desktop>
	<461E45C3.2050400@chelsio.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Apr 2007 08:23:57 -0700
In-Reply-To: <461E45C3.2050400@chelsio.com> (Divy Le Ray's message of "Thu, 12 Apr 2007 07:44:19 -0700")
Message-ID: <adaveg1ipki.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Apr 2007 15:23:57.0174 (UTC) FILETIME=[968A3160:01C77D16]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So is the cxgb3 net driver change in question already in Linus's tree?
What is the exact patch that this change goes with?
