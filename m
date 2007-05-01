Return-Path: <linux-kernel-owner+w=401wt.eu-S965044AbXEAUW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044AbXEAUW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030300AbXEAUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:22:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44545 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965044AbXEAUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:22:27 -0400
Date: Tue, 1 May 2007 21:26:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] block: Convert to generic boolean
Message-ID: <20070501212619.46cf36f8@the-village.bc.nu>
In-Reply-To: <20070501190607.32350.4822.sendpatchset@thinktank.campus.ltu.se>
References: <20070501190607.32350.4822.sendpatchset@thinktank.campus.ltu.se>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 21:08:36 +0200 (MEST)
Richard Knutsson <ricknu-0@student.ltu.se> wrote:

> Convert to generic boolean
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Compile-tested but most arch/conf tested failed for other reasons then this
> Diffed against Linus' git-tree.

If you can't build test stuff like ps2esdi then its best to leave it
alone - we know the old driver code works/worked and in a few years even
James won't have any working PS/2 hardware left

Alan
