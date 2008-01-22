Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYAVXBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYAVXBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbYAVXA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:00:26 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:16860 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262AbYAVXAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:00:22 -0500
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH RESEND 3/3] RDMA/cxgb3: Mark qp as privileged based on user capabilities.
X-Message-Flag: Warning: May contain useful information
References: <20080121204130.3820.11053.stgit@dell3.ogc.int>
	<20080121204213.3820.12396.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 22 Jan 2008 15:00:13 -0800
In-Reply-To: <20080121204213.3820.12396.stgit@dell3.ogc.int> (Steve Wise's message of "Mon, 21 Jan 2008 14:42:13 -0600")
Message-ID: <adaodbdsbya.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Jan 2008 23:00:14.0102 (UTC) FILETIME=[8C30A360:01C85D4A]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied 1-3
