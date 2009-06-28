Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbZF1VQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbZF1VQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZF1VQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:16:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:57115 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZF1VP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:15:59 -0400
Date: Sun, 28 Jun 2009 23:16:01 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Remove unnecessary semicolons
In-Reply-To: <1246214678.13673.31.camel@Joe-Laptop.home>
Message-ID: <alpine.LNX.2.00.0906282314250.18021@wotan.suse.de>
References: <cover.1246173664.git.joe@perches.com>  <1ee6dd55768ebbbeb505c47e2944b683633be630.1246173680.git.joe@perches.com>  <20090628185102.47663e61@lxorguk.ukuu.org.uk>  <20090628.113325.244931913.davem@davemloft.net>
 <1246214678.13673.31.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009, Joe Perches wrote:

> > I'm all for this, to be honest, and I'm very much for rolling this 
> > into one single patch too :)
> Here's just the single one, but doesn't a patch that span multiple 
> arches make it a bit more troublesome for the arch maintainers?

Apparently subsystem maintainers started to pick the relevant bits into 
their trees.

After checking which ones were merged and which ones were not, if you 
could create a single patch with the remaining bits, I'll happily take 
them through the trivial queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs

