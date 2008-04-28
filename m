Return-Path: <linux-kernel-owner+w=401wt.eu-S968271AbYD1XIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968271AbYD1XIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935887AbYD1Wpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:45:47 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:24059 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935582AbYD1Wpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:45:43 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org, divy@chelsio.com, felix@chelsio.com
Subject: Re: [PATCH 2.6.26 2/3] RDMA/cxgb3: Correctly set the max_mr_size device attribute.
References: <20080427155456.31018.22282.stgit@dell3.ogc.int>
	<20080427160008.31018.15516.stgit@dell3.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 28 Apr 2008 15:45:40 -0700
In-Reply-To: <20080427160008.31018.15516.stgit@dell3.ogc.int> (Steve Wise's
	message of "Sun, 27 Apr 2008 11:00:08 -0500")
Message-ID: <adalk2xzjhn.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2008 22:45:41.0058 (UTC) FILETIME=[95E27220:01C8A981]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
