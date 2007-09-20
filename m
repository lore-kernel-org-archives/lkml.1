Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbXITQb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbXITQb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbXITQbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:31:39 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:64049 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbXITQbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:31:36 -0400
X-IronPort-AV: E=Sophos;i="4.20,279,1186383600"; 
   d="scan'208";a="400589500"
To: "Sean Hefty" <sean.hefty@intel.com>
Cc: "'Steve Wise'" <swise@opengridcomputing.com>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
Subject: Re: [PATCH] RDMA/CMA: Use neigh_event_send() to initiate neighbour discovery.
X-Message-Flag: Warning: May contain useful information
References: <20070912100025.3190.89259.stgit@dell3.ogc.int>
	<000101c7f568$9275b520$ff0da8c0@amr.corp.intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 20 Sep 2007 09:31:27 -0700
In-Reply-To: <000101c7f568$9275b520$ff0da8c0@amr.corp.intel.com> (Sean Hefty's message of "Wed, 12 Sep 2007 11:13:08 -0700")
Message-ID: <ada1wctguxs.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Sep 2007 16:31:29.0330 (UTC) FILETIME=[B251E120:01C7FBA3]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Roland - can you please queue this up for 2.6.24?

Done, thanks.
