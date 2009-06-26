Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZFZAU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZFZAU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZFZAUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:20:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbZFZAUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:20:16 -0400
Date: Thu, 25 Jun 2009 17:20:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-06-25-15-49 uploaded
Message-Id: <20090625172012.6d05eb1a.akpm@linux-foundation.org>
In-Reply-To: <4A440D59.50400@oracle.com>
References: <200906252249.n5PMnaPt016847@imap1.linux-foundation.org>
	<4A440D59.50400@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 16:50:49 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-06-25-15-49 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> shrink_slab-handle-bad-shrinkers.patch:
> 
> mm/vmscan.c: In function 'do_try_to_free_pages':
> mm/vmscan.c:1697: error: too few arguments to function 'disable_swap_token'
> mm/vmscan.c: In function 'balance_pgdat':
> mm/vmscan.c:1869: error: too few arguments to function 'disable_swap_token'
> mm/vmscan.c: In function '__zone_reclaim':
> mm/vmscan.c:2425: error: too few arguments to function 'disable_swap_token'

eh, OK, thanks, I'll drop it.
