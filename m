Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYAHUJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYAHUJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYAHUJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:09:14 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:36085 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYAHUJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:09:12 -0500
X-IronPort-AV: E=Sophos;i="4.24,259,1196668800"; 
   d="scan'208";a="6321941"
To: Dave Dillow <dillowda@ornl.gov>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [2.6.24-rc minor bugfix] IB/srp: release transport before removing host
X-Message-Flag: Warning: May contain useful information
References: <1199393485.7561.51.camel@lap75545.ornl.gov>
	<20080104094722F.fujita.tomonori@lab.ntt.co.jp>
	<1199414359.3636.13.camel@obelisk.thedillows.org>
	<20080104115427F.fujita.tomonori@lab.ntt.co.jp>
	<1199417741.3636.18.camel@obelisk.thedillows.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 08 Jan 2008 12:09:08 -0800
In-Reply-To: <1199417741.3636.18.camel@obelisk.thedillows.org> (Dave Dillow's message of "Thu, 03 Jan 2008 22:35:41 -0500")
Message-ID: <aday7b084gr.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jan 2008 20:09:08.0573 (UTC) FILETIME=[53ACB8D0:01C85232]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
