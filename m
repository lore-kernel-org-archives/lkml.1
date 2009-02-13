Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZBMFn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZBMFn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbZBMFnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:43:16 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:39001 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZBMFnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:43:15 -0500
X-IronPort-AV: E=Sophos;i="4.38,200,1233532800"; 
   d="scan'208";a="248681075"
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: general@lists.openfabrics.org, randy.dunlap@oracle.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.30] RDMA/cxgb3: remove modulo math from build_rdma_recv().
References: <20090211222915.19520.22647.stgit@dell3.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 12 Feb 2009 21:43:14 -0800
In-Reply-To: <20090211222915.19520.22647.stgit@dell3.ogc.int> (Steve Wise's
	message of "Wed, 11 Feb 2009 16:29:15 -0600")
Message-ID: <adad4dmao3x.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Feb 2009 05:43:14.0704 (UTC) FILETIME=[F6D0F100:01C98D9D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
