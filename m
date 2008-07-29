Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbYG2Rbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbYG2Rbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYG2Rbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:31:33 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:50147 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYG2Rbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:31:32 -0400
X-IronPort-AV: E=Sophos;i="4.31,273,1215388800"; 
   d="scan'208";a="18941795"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Linux v2.6.27-rc1
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
	<200807290927.12101.jbarnes@virtuousgeek.org>
	<alpine.LFD.1.10.0807290945030.3334@nehalem.linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 29 Jul 2008 10:31:31 -0700
In-Reply-To: <alpine.LFD.1.10.0807290945030.3334@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 29 Jul 2008 09:59:18 -0700 (PDT)")
Message-ID: <adafxps4mx8.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Jul 2008 17:31:31.0453 (UTC) FILETIME=[F0A5FAD0:01C8F1A0]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >    That may not sound like much, but it's enough to make me worry about 
 >    'next'. I worry that 'it has been in next' has become a code-word for 
 >    "pull this, because it's good", and I'm not at all convinced that 
 >    'next' sees any real critical checking.

I've been mentioning that my trees have been in next as code for, "I
don't think this should break the build or clash too badly with anything
else."  And next has been useful to me on several occasions for catching
that sort of problem before things hit mainline.

 - R.
