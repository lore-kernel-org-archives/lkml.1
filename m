Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZD2HiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZD2HiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZD2HiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:38:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34101 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZD2HiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:38:11 -0400
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3] x86: MCE: Re-implement MCE log ring buffer as per-CPU ring buffer
From: Andi Kleen <andi@firstfloor.org>
References: <1240989881.6842.1213.camel@yhuang-dev.sh.intel.com>
Date: Wed, 29 Apr 2009 09:38:08 +0200
In-Reply-To: <1240989881.6842.1213.camel@yhuang-dev.sh.intel.com> (Huang Ying's message of "Wed, 29 Apr 2009 15:24:41 +0800")
Message-ID: <8763gnrjtr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> CC: Andi Kleen <ak@linux.intel.com>

Looks good. I think this should go into 2.6.31

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
