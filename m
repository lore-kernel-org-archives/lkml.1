Return-Path: <linux-kernel-owner+w=401wt.eu-S1422921AbXBHXMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422921AbXBHXMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422960AbXBHXMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:12:39 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:4330 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422921AbXBHXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:12:38 -0500
X-IronPort-AV: i="4.13,302,1167638400"; 
   d="scan'208"; a="110561943:sNHT39475476"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
X-Message-Flag: Warning: May contain useful information
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 08 Feb 2007 15:12:30 -0800
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 8 Feb 2007 15:07:10 -0800")
Message-ID: <ada3b5gqm5d.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Feb 2007 23:12:32.0632 (UTC) FILETIME=[9CA25F80:01C74BD6]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > infiniband-work-around-gcc-bug-on-sparc64.patch
 > ehca-fix-memleak-on-module-unloading.patch

 >  -> roland

Sorry, I misunderstood your email.  I thought it was just a CC of
stuff you were already merging.  I will handle these patches.

 - R.
