Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbYLHJWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbYLHJWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYLHJWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:22:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:51078 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751058AbYLHJWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:22:33 -0500
Date: Mon, 8 Dec 2008 10:22:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nick Andrew <nick@nick-andrew.net>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>,
       Joe Perches <joe@perches.com>
Subject: Re: linux-next: trivial tree
In-Reply-To: <20081205010421.GA31220@mail.local.tull.net>
Message-ID: <alpine.LNX.1.10.0812081021120.21089@jikos.suse.cz>
References: <alpine.LNX.1.10.0811271145180.19853@jikos.suse.cz> <20081205010421.GA31220@mail.local.tull.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, Nick Andrew wrote:

> > I have taken over trivial patches maintainership from Jesper.
> FYI, you might (still) have a patch in your tree from me called 'Tighten 
> Use of Loose' which fixes spelling errors in a number of files across 
> the repository. It's been a few months and I noticed it's not yet in 
> Linus' repository, presumably due to it conflicting with functional 
> changes done in the subsystems. So I've split it into one-patch-per-file 
> now and I'll submit to the subsystem maintainers individually, with the 
> help of Joe Perches' annotated MAINTAINERS file and email lookup script.

Hi Nick,

well, that patch didn't reach me yet. Jesper told me that he will 
eventually flush his whole unprocessed queue (which probably contains also 
the mentioned patch) my way, so that I can merge it, but that didn't 
happen yet.

-- 
Jiri Kosina
SUSE Labs
