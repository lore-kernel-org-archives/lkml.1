Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbXHBVG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbXHBVG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761095AbXHBVFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:05:22 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:6937 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761015AbXHBVFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:05:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAFLksUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.19,215,1183359600"; 
   d="scan'208"; a="193358290:sNHT315340218"
To: Steve Wise <swise@opengridcomputing.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.23 2/2] iw_cxgb3: Always call low level send function via cxgb3_ofld_send().
X-Message-Flag: Warning: May contain useful information
References: <20070729201226.31659.85900.stgit@dell3.ogc.int>
	<20070729201228.31659.26300.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 02 Aug 2007 14:05:06 -0700
In-Reply-To: <20070729201228.31659.26300.stgit@dell3.ogc.int> (Steve Wise's message of "Sun, 29 Jul 2007 15:12:29 -0500")
Message-ID: <adasl713awt.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Aug 2007 21:05:06.0748 (UTC) FILETIME=[CD9F4FC0:01C7D548]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
