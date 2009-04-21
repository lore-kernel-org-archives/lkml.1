Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZDUXAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZDUXAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 19:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZDUXAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 19:00:36 -0400
Received: from sous-sol.org ([216.99.217.87]:39635 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751144AbZDUXAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 19:00:36 -0400
Date: Tue, 21 Apr 2009 15:59:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch] x64: fix FPU corruption with signals and
	preemption
Message-ID: <20090421225912.GE3036@sequoia.sous-sol.org>
References: <1239315874.27006.8026.camel@localhost.localdomain> <20090421224951.GD24073@hera.kernel.org> <49EE4DE9.2070209@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EE4DE9.2070209@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@linux.intel.com) wrote:
> Chris Wright wrote:
>>>
>>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>>> Cc: stable@kernel.org			[2.6.28.x, 2.6.29.x]
>>
>> This one get lost?
>
> No, it's queued up in tip:x86/urgent and will be pushed upstream with  
> the next push of x86 fixes to Linus.

OK, I had it marked as not upstream and not in tip, thanks for the
correction.

thanks,
-chris
