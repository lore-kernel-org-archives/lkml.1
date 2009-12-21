Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZLUMTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZLUMTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZLUMTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:19:35 -0500
Received: from mga05.intel.com ([192.55.52.89]:18947 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751403AbZLUMTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:19:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,429,1257148800"; 
   d="scan'208";a="758052695"
Message-ID: <4B2F67CD.4060700@linux.intel.com>
Date: Mon, 21 Dec 2009 13:19:25 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Zheng, Shaohui" <shaohui.zheng@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>, akpm@osdl.org,
       stable@kernel.org
Subject: Re: [PATCH ] memory-hotplug: create /sys/firmware/memmap entry for
 new memory(v3)
References: <DA586906BA1FFC4384FCFD6429ECE860302035FC@shzsmsx502.ccr.corp.intel.com>
In-Reply-To: <DA586906BA1FFC4384FCFD6429ECE860302035FC@shzsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zheng, Shaohui wrote:
> Resend t he patch(v3) after the review by the mailing list, thanks so 
> much for Dave Hansen’s comments.

Both patches look good. IMHO they should both go into .33 and
are even stable candidates. Andrew, could you add them to your tree please?

-Andi

