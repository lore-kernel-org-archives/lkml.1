Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbYLETfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbYLETfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 14:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYLETfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 14:35:22 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:38554 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbYLETfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 14:35:21 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2008 14:35:21 EST
X-IronPort-AV: E=Sophos;i="4.33,722,1220227200"; 
   d="scan'208";a="26106827"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rolandd@cisco.com>,
       raisch@de.ibm.com, hnguyen@de.ibm.com, fenkes@de.ibm.com,
       alexschm@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: [PATCH] IB/ehca: replace modulus operations in flush error completion path
References: <200812021631.58810.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 05 Dec 2008 11:25:49 -0800
In-Reply-To: <200812021631.58810.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Tue, 2 Dec 2008 16:31:56 +0100")
Message-ID: <adaabba77b6.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Dec 2008 19:25:49.0702 (UTC) FILETIME=[47C57A60:01C9570F]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
