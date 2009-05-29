Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZE2IxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZE2IxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbZE2Iwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:52:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37435 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411AbZE2Iwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:52:54 -0400
Subject: Re: [PATCH] slab: remove bootmem calling
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, mpm@selenic.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <4A1F3724.8050103@kernel.org>
References: <1243517365.11533.65.camel@penberg-laptop>
	 <4A1F3724.8050103@kernel.org>
Date: Fri, 29 May 2009 11:52:54 +0300
Message-Id: <1243587174.15371.8.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

On Thu, 2009-05-28 at 18:15 -0700, Yinghai Lu wrote:
> mem_init/kmem_cache_init is moved up
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Thanks!

I cleaned up the changelogs a bit and applied in 'topic/slab/earlyboot'
branch in my tree:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=shortlog;h=topic/slab/earlyboot

I expect Ingo to pick up these changes at some point and we can move the
development of this patch series to -tip. But for now, please send
patches against my tree.

			Pekka

