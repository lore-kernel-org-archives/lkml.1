Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbXJEB7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbXJEB7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 21:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759201AbXJEB7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 21:59:09 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:38154 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844AbXJEB7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 21:59:07 -0400
X-IronPort-AV: E=Sophos;i="4.21,233,1188802800"; 
   d="scan'208";a="179270090"
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: Re: Vague maybe ppp-related panic report for 2.6.23-rc9
X-Message-Flag: Warning: May contain useful information
References: <ada4ph6da05.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 04 Oct 2007 18:59:06 -0700
In-Reply-To: <ada4ph6da05.fsf@cisco.com> (Roland Dreier's message of "Thu, 04 Oct 2007 11:12:42 -0700")
Message-ID: <adalkai9v9x.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Oct 2007 01:59:06.0383 (UTC) FILETIME=[4FB041F0:01C806F3]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just as a quick update -- I seem to only be able to reproduce this
crash when my ppp session drops, which seems associated with marginal
signal.  And unfortunately I have great coverage at home so I haven't
been able to reproduce this again today.  Maybe on the train tomorrow
I can crash my laptop...

 - R.
