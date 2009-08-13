Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZHMJ5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZHMJ5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZHMJ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:57:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbZHMJ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:57:31 -0400
Date: Thu, 13 Aug 2009 11:57:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Joe Perches <joe@perches.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH linux-next] treewide: remove unnecessary semicolons
In-Reply-To: <1248472866.3498.79.camel@Joe-Laptop.home>
Message-ID: <alpine.LNX.2.00.0908131155510.25797@wotan.suse.de>
References: <1248472866.3498.79.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009, Joe Perches wrote:

> Previous discussion at: http://lkml.org/lkml/2009/6/28/288
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks. I have one more request if you don't mind -- please take out the 
drivers/staging part and push that one individually to Greg. I'll then 
merge the remaining bits through trivial tree.

The code in staging tree is supposed to be changing rapidly, so we'll be 
getting conflicts very often.

Thanks,

-- 
Jiri Kosina
SUSE Labs
