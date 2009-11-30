Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZK3MgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZK3MgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZK3MgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:36:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:43048 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZK3MgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:36:13 -0500
Date: Mon, 30 Nov 2009 13:36:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Hutchings <bhutchings@solarflare.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?ISO-8859-15?Q?=22Andr=E9_Goddard_Rosa=22?= 
	<andre.goddard@gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
In-Reply-To: <20091130135320.215722a2.sfr@canb.auug.org.au>
Message-ID: <alpine.LSU.2.00.0911301335570.6953@wotan.suse.de>
References: <20091130135320.215722a2.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> drivers/net/sfc/falcon.c between commit
> 127e6e10ad17585c48cba8e1dcf30d98b90ee583 ("sfc: Fix bugs in RX queue
> flushing") from the net tree and commit
> 4e5cf22a6f45b6489f84de03d3a1dfa60cc4b4e4 ("tree-wide: fix assorted typos
> all over the place") from the trivial tree.
> 
> The former removed the comment that the latter was fixing.

Dropped the falcon.c hunk from the pile, so the conflict should be gone. 
Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
