Return-Path: <linux-kernel-owner+w=401wt.eu-S1030609AbXDLRaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030609AbXDLRaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030603AbXDLRaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:30:55 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:13223 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030584AbXDLRay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:30:54 -0400
X-IronPort-AV: i="4.14,403,1170662400"; 
   d="scan'208"; a="135092310:sNHT51057792"
To: Steve Wise <swise@opengridcomputing.com>
Cc: Netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       OpenFabrics General <general@lists.openfabrics.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Divy Le Ray <divy@chelsio.com>
Subject: Re: [ofa-general] Re: [PATCH 2.6.21] iw_cxgb3 - Add set_tcb_rpl_handler.
X-Message-Flag: Warning: May contain useful information
References: <1176382594.9396.1.camel@stevo-desktop>
	<461E45C3.2050400@chelsio.com> <adaveg1ipki.fsf@cisco.com>
	<1176392566.9396.11.camel@stevo-desktop> <ada3b35ink7.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Apr 2007 10:30:48 -0700
In-Reply-To: <ada3b35ink7.fsf@cisco.com> (Roland Dreier's message of "Thu, 12 Apr 2007 09:07:20 -0700")
Message-ID: <adamz1dh54n.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Apr 2007 17:30:52.0252 (UTC) FILETIME=[517AE1C0:01C77D28]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Never mind, I see that "cxgb3 - missing CPL hanler and register
setting." has appeared in Linus's tree.  Steve, I'll ask Linus to pull
this fix today.  Jeff, never mind my question since it's too late now.

 - R.
