Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYL3W4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYL3W4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYL3W4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:56:15 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:36840 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYL3W4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:56:14 -0500
X-IronPort-AV: E=Sophos;i="4.36,304,1228089600"; 
   d="scan'208";a="221667964"
From: Roland Dreier <rdreier@cisco.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: linux-next: origin tree build failure
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
	<adavdt2ru39.fsf@cisco.com>
	<20081230193048.db7ee462.sfr@canb.auug.org.au>
	<adaljtxsma7.fsf@cisco.com>
	<20081231024654.a73f20df.sfr@canb.auug.org.au>
	<20081231095228.b21cffe0.sfr@canb.auug.org.au>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 30 Dec 2008 14:56:05 -0800
In-Reply-To: <20081231095228.b21cffe0.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Wed, 31 Dec 2008 09:52:28 +1100")
Message-ID: <adahc4ls262.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Dec 2008 22:56:08.0448 (UTC) FILETIME=[CD751000:01C96AD1]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > So instead of the revert, I will cherry-pick your fix commit just after
 > Linus' tree today on the assumption that you will send it to him ASAP.

Yes, I will batch up a few other things and send a pull request today.

 - R.
