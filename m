Return-Path: <linux-kernel-owner+w=401wt.eu-S1946212AbXD3X7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946212AbXD3X7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946210AbXD3X7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:59:25 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:44489 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946204AbXD3X7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:59:22 -0400
X-IronPort-AV: i="4.14,472,1170662400"; 
   d="scan'208"; a="417246621:sNHT44076576"
To: Steve Wise <swise@opengridcomputing.com>
Cc: jeff@garzik.org, divy@chelsio.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.22 5/5] iw_cxgb3: Update required firmware revision to 4.0.0.
X-Message-Flag: Warning: May contain useful information
References: <20070426202057.24234.56383.stgit@dell3.ogc.int>
	<20070426202126.24234.71523.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 30 Apr 2007 16:59:11 -0700
In-Reply-To: <20070426202126.24234.71523.stgit@dell3.ogc.int> (Steve Wise's message of "Thu, 26 Apr 2007 15:21:26 -0500")
Message-ID: <adad51ljtww.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Apr 2007 23:59:12.0043 (UTC) FILETIME=[8CAC57B0:01C78B83]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I applied all 5, with the FW version change rolled up into #4/5.
