Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYKFPJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYKFPJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKFPJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:09:41 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:33484 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYKFPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:09:41 -0500
Date: Thu, 6 Nov 2008 09:08:44 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 5/7] x86_64: Support for cpu ops
In-Reply-To: <20081106071206.GH15731@elte.hu>
Message-ID: <Pine.LNX.4.64.0811060907570.3595@quilx.com>
References: <20081105231634.133252042@quilx.com> <20081105231649.108433550@quilx.com>
 <20081106071206.GH15731@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Ingo Molnar wrote:

> hm, what happened to the rebase-PDA-to-percpu-area optimization
> patches you guys were working on? I remember there was some binutils
> flakiness - weird crashes and things like that. Did you ever manage to
> stabilize it? It would be sad if only 32-bit could take advantage of
> the optimized ops.

I thought that was in your tree? I saw a conflict in -next with the zero
based stuff a couple of weeks ago. Mike is working on that AFAICT.

