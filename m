Return-Path: <linux-kernel-owner+w=401wt.eu-S936329AbXGWVEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936329AbXGWVEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934149AbXGWVEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:04:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50089 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933207AbXGWVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:04:45 -0400
Date: Mon, 23 Jul 2007 14:04:44 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Matt Mackall <mpm@selenic.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] mm: Remove slab destructors from
 kmem_cache_create().
Message-ID: <20070723140444.159343b2@schroedinger.engr.sgi.com>
In-Reply-To: <20070721234227.GA8303@linux-sh.org>
References: <20070720012846.GA22487@linux-sh.org>
	<20070721212851.GH11166@waste.org>
	<20070721234227.GA8303@linux-sh.org>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please do not merge this patch. I will reuse the destructor field for
the kmem_cache_ops in the slab defrag patchset. If you apply this patch
then I need to readd the parameter later.
