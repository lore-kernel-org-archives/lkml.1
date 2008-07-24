Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYGXUJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYGXUJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYGXUJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:09:30 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:30384 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYGXUJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:09:29 -0400
X-IronPort-AV: E=Sophos;i="4.31,248,1215388800"; 
   d="scan'208";a="57313476"
From: Roland Dreier <rdreier@cisco.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Grant Coady <gcoady.lk@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how much stuff is no longer "EXPERIMENTAL"?
References: <alpine.LFD.1.10.0807241114000.4119@localhost.localdomain>
	<h2ih845fmasm3coi3qapmqkknj0ghp6k7t@4ax.com>
	<alpine.LFD.1.10.0807241606240.6474@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Jul 2008 13:09:27 -0700
In-Reply-To: <alpine.LFD.1.10.0807241606240.6474@localhost.localdomain>
	(Robert P. J. Day's message of "Thu, 24 Jul 2008 16:06:30 -0400
	(EDT)")
Message-ID: <adar69jvybs.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Jul 2008 20:09:27.0356 (UTC) FILETIME=[2CA947C0:01C8EDC9]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think INFINIBAND_IPOIB_CM is no long EXPERIMENTAL.  I'll remove the tag.
