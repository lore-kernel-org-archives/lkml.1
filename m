Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZDVPz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZDVPz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZDVPzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:55:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZDVPzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:55:46 -0400
Message-ID: <49EF3DE2.6000201@zytor.com>
Date: Wed, 22 Apr 2009 08:55:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <49EEFD88.1030604@linux.intel.com>
In-Reply-To: <49EEFD88.1030604@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> And then restart here? Add 32bit workarounds, add hook
> to initialize p5/winchip, make 64bit code 32bit clean.
> That can come straight from my patchkit. I can do that
> if there is interest.
> 

Could you come up with a tree we can look at?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

