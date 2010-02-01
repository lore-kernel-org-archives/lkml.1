Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0BAVjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:39:16 -0500
Received: from tundra.namei.org ([65.99.196.166]:40969 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab0BAVjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:39:14 -0500
Date: Tue, 2 Feb 2010 08:38:09 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH V9] RO/NX protection for loadable kernel modules
In-Reply-To: <817ecb6f1002010829m712ffff4hfb64ff3ea236e1f1@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1002020836480.3489@tundra.namei.org>
References: <817ecb6f1002010829m712ffff4hfb64ff3ea236e1f1@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010, Siarhei Liakh wrote:

> The patch have been developed for Linux 2.6.33-rc5 by Siarhei Liakh
> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
> 
> ---
> 
> Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
> Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>

Reviewed-by: James Morris <jmorris@namei.org>

I gather it would make sense for these to go in via Ingo's tree.

-- 
James Morris
<jmorris@namei.org>
