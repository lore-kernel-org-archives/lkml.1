Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZF3RRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZF3RRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZF3RRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:17:09 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4446 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZF3RRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:17:08 -0400
Subject: Re: [PATCH] Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <alpine.LNX.2.00.0906282314250.18021@wotan.suse.de>
References: <cover.1246173664.git.joe@perches.com>
	 <1ee6dd55768ebbbeb505c47e2944b683633be630.1246173680.git.joe@perches.com>
	 <20090628185102.47663e61@lxorguk.ukuu.org.uk>
	 <20090628.113325.244931913.davem@davemloft.net>
	 <1246214678.13673.31.camel@Joe-Laptop.home>
	 <alpine.LNX.2.00.0906282314250.18021@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 10:15:53 -0700
Message-Id: <1246382153.6259.2.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 23:16 +0200, Jiri Kosina wrote:
> On Sun, 28 Jun 2009, Joe Perches wrote:
> > > I'm all for this, to be honest, and I'm very much for rolling this 
> > > into one single patch too :)
> > Here's just the single one, but doesn't a patch that span multiple 
> > arches make it a bit more troublesome for the arch maintainers?
> Apparently subsystem maintainers started to pick the relevant bits into 
> their trees.
> After checking which ones were merged and which ones were not, if you 
> could create a single patch with the remaining bits, I'll happily take 
> them through the trivial queue.

I've no idea who picks up what.
Should this be rerolled against linux-next in a couple of weeks?

