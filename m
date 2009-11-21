Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZKUQGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZKUQGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbZKUQGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:06:50 -0500
Received: from isilmar.linta.de ([213.133.102.198]:55259 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754922AbZKUQGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:06:49 -0500
Date: Sat, 21 Nov 2009 17:06:54 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Julia Lawall <julia@diku.dk>, linux-pcmcia@lists.infradead.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       walter harms <wharms@bfs.de>
Subject: Re: [PATCH 3/8] drivers/pcmcia: remove unnecessary kzalloc
Message-ID: <20091121160654.GA11292@isilmar.linta.de>
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Julia Lawall <julia@diku.dk>, linux-pcmcia@lists.infradead.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	walter harms <wharms@bfs.de>
References: <Pine.LNX.4.64.0911211250090.23681@ask.diku.dk> <4B07E0CB.6000508@bfs.de> <Pine.LNX.4.64.0911211611510.26930@ask.diku.dk> <20091121155135.GB13956@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091121155135.GB13956@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

> Thanks for the additional info which allows me to track which patch it
> corresponds with.  As an aside, it's really not nice to git pull and
> then edit the commits afterwards - that's much worse than rebasing.
> When trees are pulled, the act of merging it conveys sufficent "sign-off".

It was not a git pull and edit, as I told you in a mail sent on Nov 02:

> Thanks! I've applied the patches you sent me by mail, though, as your tree
> was based on something more recent from Linus than my tree, and I wanted to
> avoid a merge of Linus' tree into my tree.

Best,
	Dominik
