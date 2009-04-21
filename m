Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZDUWvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZDUWvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZDUWvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:51:24 -0400
Received: from mga10.intel.com ([192.55.52.92]:60135 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751644AbZDUWvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:51:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,226,1239001200"; 
   d="scan'208";a="683657674"
Message-ID: <49EE4DE9.2070209@linux.intel.com>
Date: Tue, 21 Apr 2009 15:51:21 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch] x64: fix FPU corruption with signals and	preemption
References: <1239315874.27006.8026.camel@localhost.localdomain> <20090421224951.GD24073@hera.kernel.org>
In-Reply-To: <20090421224951.GD24073@hera.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
>>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>> Cc: stable@kernel.org			[2.6.28.x, 2.6.29.x]
> 
> This one get lost?
> 

No, it's queued up in tip:x86/urgent and will be pushed upstream with 
the next push of x86 fixes to Linus.

	-hpa
