Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbYBYX5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbYBYX5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbYBYX5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:57:37 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:44168 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056AbYBYX5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:57:35 -0500
X-IronPort-AV: E=Sophos;i="4.25,404,1199692800"; 
   d="scan'208";a="14638455"
To: gstreiff@neteffect.com
Cc: general@lists.openfabrics.org, jlacombe@neteffect.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6 8/8] RDMA/nes: Fix interrupt moderation low threshold
X-Message-Flag: Warning: May contain useful information
References: <200802211434.m1LEYwnH005193@velma.neteffect.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 25 Feb 2008 15:57:19 -0800
In-Reply-To: <200802211434.m1LEYwnH005193@velma.neteffect.com> (gstreiff@neteffect.com's message of "Thu, 21 Feb 2008 08:34:58 -0600")
Message-ID: <adalk58y4gw.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Feb 2008 23:57:19.0708 (UTC) FILETIME=[280E21C0:01C8780A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied all 8 patches
