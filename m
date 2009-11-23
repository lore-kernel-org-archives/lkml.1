Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZKWJUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZKWJUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZKWJUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:20:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbZKWJUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:20:17 -0500
Date: Mon, 23 Nov 2009 10:20:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel.h: Fix kernel-doc notation
In-Reply-To: <200911231220.26402.rusty@rustcorp.com.au>
Message-ID: <alpine.LSU.2.00.0911231019400.18626@wotan.suse.de>
References: <1258877529.4495.43.camel@ht.satnam> <200911231220.26402.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Rusty Russell wrote:

> On Sun, 22 Nov 2009 06:42:09 pm Jaswinder Singh Rajput wrote:
> > 
> > Fix the following htmldocs warnings:
> > 
> >   Warning(include/linux/kernel.h:708): No description found for parameter 'condition'
> >   Warning(include/linux/kernel.h:708): Excess function parameter 'cond' description in 'BUILD_BUG_ON'
> 
> This look like  ajob for trivial@kernel.org or akpm?
> 
> For the pedants: Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks, but ... what tree is this against? Certainly doesn't apply for 
current Linus' tree.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
