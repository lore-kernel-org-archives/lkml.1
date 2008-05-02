Return-Path: <linux-kernel-owner+w=401wt.eu-S934399AbYEBR60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399AbYEBR60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYEBR6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:58:13 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:35786 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbYEBR6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:58:12 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH 2.6.26 1/3] RDMA/cxgb3: QP flush fixes
References: <20080502161741.30500.95337.stgit@dell3.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 May 2008 10:58:10 -0700
In-Reply-To: <20080502161741.30500.95337.stgit@dell3.ogc.int> (Steve Wise's
	message of "Fri, 02 May 2008 11:17:41 -0500")
Message-ID: <adamyn84mh9.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 17:58:10.0792 (UTC) FILETIME=[1593BE80:01C8AC7E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied all 3... (1/3 was against a slightly old tree, so I had
to fix up __FUNCTION__ -> __func__ in the context of the diffs)
