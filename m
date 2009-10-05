Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbZJEHH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbZJEHH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbZJEHH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:07:26 -0400
Received: from mga10.intel.com ([192.55.52.92]:46767 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753708AbZJEHH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:07:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,505,1249282800"; 
   d="scan'208";a="499846977"
Message-ID: <4AC99AEC.3000504@linux.intel.com>
Date: Mon, 05 Oct 2009 00:06:20 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] x86, mce: make mce_log buffer to per-CPU
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com> <4AC99483.7020100@jp.fujitsu.com>
In-Reply-To: <4AC99483.7020100@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> (This piece originates from Huang's patch, titled:
>  "x86, MCE: Fix bugs and issues of MCE log ring buffer")

You should use proper From: headers then for correct attribution.

-Andi
