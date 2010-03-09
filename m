Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab0CIRhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:37:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0CIRhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:37:35 -0500
Subject: Re: [PATCH] x86: Add optimized popcnt variants
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
In-Reply-To: <20100309173234.GE2371@aftab>
References: <20100223190614.GB2401@aftab> <4B875BBD.4060104@zytor.com>
	 <20100226074714.GA15310@aftab> <4B88097E.7010608@zytor.com>
	 <20100227082807.GA21706@aftab> <4B8979DA.9000201@zytor.com>
	 <20100309153628.GA2371@aftab> <1268149840.5037.3.camel@laptop>
	 <20100309162352.GB2371@aftab> <1268152369.5037.10.camel@laptop>
	 <20100309173234.GE2371@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 18:37:28 +0100
Message-ID: <1268156248.5037.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 18:32 +0100, Borislav Petkov wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue, Mar 09, 2010 at 05:32:49PM +0100
> 
> > I thought the patch did that, see this hunk (straight from
> > http://lkml.org/lkml/2010/2/4/119 ):
> 
> Bollocks, I seem to have lost that hunk while applying the patch by
> foot, sorry for the noise.
> 
> By the way, I can't seem to find your patch in Andrew's tree, is it
> still going through his tree?

I hope so, Andrew, need me to resend or do you still have a copy?



