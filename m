Return-Path: <linux-kernel-owner+w=401wt.eu-S1767442AbXECQDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767442AbXECQDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767446AbXECQDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:03:42 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:23405 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767442AbXECQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:03:40 -0400
X-IronPort-AV: i="4.14,486,1170662400"; 
   d="scan'208"; a="483254658:sNHT42995212"
To: Andi Kleen <ak@suse.de>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Why ssse3?
X-Message-Flag: Warning: May contain useful information
References: <46391392.4070706@redhat.com> <200705030046.07152.ak@suse.de>
	<4639171A.3050004@redhat.com> <200705031052.31611.ak@suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 03 May 2007 09:03:36 -0700
In-Reply-To: <200705031052.31611.ak@suse.de> (Andi Kleen's message of "Thu, 3 May 2007 10:52:31 +0200")
Message-ID: <aday7k5evxj.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 May 2007 16:03:36.0850 (UTC) FILETIME=[9B9CAF20:01C78D9C]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > PNI (Prescott New Instructions) was the original engineering code name. Unfortunately
 > it was added too early before the marketing name was known and then it couldn't be 
 > changed anymore.

... and just to make things more fun, SSE4 is sometimes called Penryn
New Instructions -- PNI all over again.

 - R.
