Return-Path: <linux-kernel-owner+w=401wt.eu-S1763467AbZFLOh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763467AbZFLOh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZFLOhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:37:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbZFLOhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:37:19 -0400
Date: Fri, 12 Jun 2009 16:37:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: walter harms <wharms@bfs.de>
Cc: Jiri Kosina <trivial@kernel.org>,
       Markus Heidelberg <markus.heidelberg@web.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] trivial: update the Kernel Janitors' web-page URL
In-Reply-To: <4A322A73.4040104@bfs.de>
Message-ID: <alpine.LRH.2.00.0906121636060.31685@twin.jikos.cz>
References: <1244761228-32644-1-git-send-email-markus.heidelberg@web.de> <alpine.LNX.2.00.0906121057240.7457@wotan.suse.de> <4A322A73.4040104@bfs.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, walter harms wrote:

> > BTW, I haven't followed kernel janitors project for a while, is it 
> > still active? Skimming through the web, I can see some TODOs from 
> > 2001, hence the question :)
> the project is still active.
> the last patch was yesterday:
> <clip>
> Trivial patch which adds the __init and __exit macros to the module_init /
> module_exit functions to the following modules from drivers/mtd/
>  devices/m25p80.c
>  devices/slram.c
>  linux version 2.6.30
>  ftl.c
>  nand/cafe_nand.c
>  nand/cmx270_nand.c
> <clip/>

Well, yes, I have been CCed on that patch. My question was rather about 
whether there is anyone in the project actively looking at the posted 
patches, reviewing them, pushing them to appropriate maintainers, etc. I 
don't recall having seen anything like that in the past.

Thanks,

-- 
Jiri Kosina
SUSE Labs

