Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYL3PnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYL3PnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 10:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYL3Pm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 10:42:59 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:22845 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYL3Pm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 10:42:58 -0500
X-IronPort-AV: E=Sophos;i="4.36,302,1228089600"; 
   d="scan'208";a="123633953"
From: Roland Dreier <rdreier@cisco.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: linux-next: origin tree build failure
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	<adavdt2ru39.fsf@cisco.com>
	<20081230193048.db7ee462.sfr@canb.auug.org.au>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 30 Dec 2008 07:41:36 -0800
In-Reply-To: <20081230193048.db7ee462.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Tue, 30 Dec 2008 19:30:48 +1100")
Message-ID: <adaljtxsma7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Dec 2008 15:41:36.0883 (UTC) FILETIME=[1997F430:01C96A95]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I can drop the revert after your fix goes into Linus' tree (since that is
 > where the breakage is) ... looking forward to it, thanks.

Shouldn't it work if the fix is in my for-next branch, since you pull
that as part of the -next tree?  Or am I unclear on how -next works?

 - R.
