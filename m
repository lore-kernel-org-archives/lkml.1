Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbXHBVIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbXHBVIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761210AbXHBVGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:06:46 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:5082 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761063AbXHBVGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:06:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABbksUarR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.19,215,1183359600"; 
   d="scan'208"; a="509796181:sNHT25363372"
To: Steve Wise <swise@opengridcomputing.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.23 1/2] Make the iw_cxgb3 module parameters writable.
X-Message-Flag: Warning: May contain useful information
References: <20070729201226.31659.85900.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 02 Aug 2007 14:06:41 -0700
In-Reply-To: <20070729201226.31659.85900.stgit@dell3.ogc.int> (Steve Wise's message of "Sun, 29 Jul 2007 15:12:26 -0500")
Message-ID: <adaodhp3au6.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Aug 2007 21:06:41.0842 (UTC) FILETIME=[064D8120:01C7D549]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks... I actually applied this for 2.6.24, since it's not really a
fix for anything, and the 2.6.23 window is closed.
