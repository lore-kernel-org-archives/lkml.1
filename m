Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab0BVKYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:24:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:55873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab0BVKYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:24:22 -0500
Date: Mon, 22 Feb 2010 11:24:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frans Pop <elendil@planet.nl>, David Miller <davem@davemloft.net>,
       Daniel Mack <daniel@caiaq.de>
Subject: Re: linux-next: manual merge of the trivial tree with the sparc
 tree
In-Reply-To: <20100222141341.f5c92be4.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1002221123580.30967@pobox.suse.cz>
References: <20100222141341.f5c92be4.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> arch/sparc/kernel/leon_kernel.c between commit
> 0da2b300b91ddeb9944c3fb4faaf78c1c482c0af ("sparc: remove trailing space
> in messages") from the sparc tree and commit
> 3ad2f3fbb961429d2aa627465ae4829758bc7e07 ("tree-wide: Assorted spelling
> fixes") from the trivial tree.
> 
> The former also fixed the spelling mistake fixed by the latter.

Thanks, I have reverted the chunk in question in my tree.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
