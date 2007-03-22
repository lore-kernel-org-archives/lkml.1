Return-Path: <linux-kernel-owner+w=401wt.eu-S934171AbXCVR6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171AbXCVR6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 13:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934170AbXCVR6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 13:58:32 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:28861 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934158AbXCVR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 13:58:31 -0400
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Netdev@vger.kernel.org,
       General@lists.openfabrics.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH 2.6.21] iw_cxgb3: Handle build_phys_page_list() failure in iwch_reregister_phys_mem().
X-Message-Flag: Warning: May contain useful information
References: <1174577900.16862.27.camel@stevo-desktop>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 22 Mar 2007 10:58:25 -0700
In-Reply-To: <1174577900.16862.27.camel@stevo-desktop> (Steve Wise's message of "Thu, 22 Mar 2007 10:38:20 -0500")
Message-ID: <ada7it9gny6.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Mar 2007 17:58:25.0511 (UTC) FILETIME=[B0396F70:01C76CAB]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
