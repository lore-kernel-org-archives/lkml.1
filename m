Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYKFQNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYKFQNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYKFQND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:13:03 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:60489 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYKFQND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:13:03 -0500
Date: Thu, 6 Nov 2008 10:11:49 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 5/7] x86_64: Support for cpu ops
In-Reply-To: <20081106151558.GB1644@elte.hu>
Message-ID: <Pine.LNX.4.64.0811061009260.5349@quilx.com>
References: <20081105231634.133252042@quilx.com> <20081105231649.108433550@quilx.com>
 <20081106071206.GH15731@elte.hu> <Pine.LNX.4.64.0811060907570.3595@quilx.com>
 <20081106151558.GB1644@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Ingo Molnar wrote:

> But it's not actually utilized on x86. AFAICS you guys never came back
> with working patches for that (tip/x86/percpu is empty currently), and
> now i see something related on lkml on a separate track not Cc:-ed to
> the x86 folks so i thought i'd ask whether more coordination is
> desired here.

We should definitely look into this but my priorities have changed a bit.
32 bit is far more significant for me now.

Could you point me to a post that describes the currently open issues with
x86_64? Mike handled that before.

> So ... what's the merge plan here? I like your fundamental idea, it's
> a nice improvement in a couple of areas and i'd like to help out make
> it happen. Also, the new per-cpu allocator would be nice for the
> sparseirq code.

Right. Its good in many areas.
