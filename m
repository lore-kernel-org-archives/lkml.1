Return-Path: <linux-kernel-owner+w=401wt.eu-S939861AbXG3UUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939861AbXG3UUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937745AbXG3UU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:20:27 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:35219 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763487AbXG3UUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:20:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAJPkrUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.19,200,1183359600"; 
   d="scan'208"; a="508495358:sNHT26416516"
To: Steve Wise <swise@opengridcomputing.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.23 1/2] Make the iw_cxgb3 module parameters writable.
X-Message-Flag: Warning: May contain useful information
References: <20070729201226.31659.85900.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 30 Jul 2007 13:20:21 -0700
In-Reply-To: <20070729201226.31659.85900.stgit@dell3.ogc.int> (Steve Wise's message of "Sun, 29 Jul 2007 15:12:26 -0500")
Message-ID: <adad4y9skxm.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jul 2007 20:20:21.0718 (UTC) FILETIME=[0DFAFF60:01C7D2E7]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ugh, missed these before my last merge...

anyway:

why do we want to parameters writable?  a good changelog tells me
what, why and how, and this changelog just covered the "what".  Also,
I assume you've checked that it's OK for these variables to change at
any time?
