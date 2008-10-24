Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYJXEP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYJXEP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYJXEOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:14:55 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26752 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYJXEOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:14:54 -0400
X-IronPort-AV: E=Sophos;i="4.33,474,1220227200"; 
   d="scan'208";a="181644019"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc1
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 23 Oct 2008 21:14:51 -0700
In-Reply-To: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 23 Oct 2008 21:10:29 -0700 (PDT)")
Message-ID: <adar666sk78.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Oct 2008 04:14:53.0010 (UTC) FILETIME=[107EA320:01C9358F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >  - Most screwed-up clock award goes to:
 > 
 > 	Greg Kroah-Hartman
 > 
 >    for his commit 51b90540, which claims to be from April 9 - six years 
 >    ago! And it's a fix to a driver that was merged this July!

Maybe that commit really is from a time before printk supported the
"%zd" format for size_t :)

 - R.
