Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYGOGwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYGOGwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYGOGwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:52:18 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:12526 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYGOGwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:52:17 -0400
X-IronPort-AV: E=Sophos;i="4.30,364,1212364800"; 
   d="scan'208";a="52997187"
From: Roland Dreier <rdreier@cisco.com>
To: Eli Cohen <eli@dev.mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] ***SPAM*** InfiniBand/RDMA merge plans for 2.6.27
References: <ada8ww5jbaf.fsf@cisco.com> <20080714135009.GA29500@mtls03>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 14 Jul 2008 23:52:15 -0700
In-Reply-To: <20080714135009.GA29500@mtls03> (Eli Cohen's message of "Mon, 14
	Jul 2008 16:50:09 +0300")
Message-ID: <ada3ambiqqo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jul 2008 06:52:16.0013 (UTC) FILETIME=[513DCBD0:01C8E647]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > There is this patch that I did not recieve your response for. We think
 > it's reasonable to do this - what do you think?
 > 
 > http://lists.openfabrics.org/pipermail/general/2008-July/052460.html

I'm ambivalent.  Seems like a minor usability improvement in some cases,
but on the other hand it seems a little strange to change the MTU behind
the user's back.  Maybe I'll stick it in -- I need to think about it.
