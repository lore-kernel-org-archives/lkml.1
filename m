Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZIYBTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZIYBTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 21:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZIYBTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 21:19:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZIYBTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 21:19:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090924180128.1fa8c0d8.akpm@linux-foundation.org>
References: <20090924180128.1fa8c0d8.akpm@linux-foundation.org> <20090924150925.06f4fa23.akpm@linux-foundation.org> <20090924141310.19746.31678.stgit@warthog.procyon.org.uk> <8852.1253839157@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       lethal@linux-sh.org, mel@csn.ul.ie, gerg@snapgear.com,
       stable@kernel.org
Subject: Re: [PATCH] NOMMU: Fix MAP_PRIVATE mmap() of objects where the data can be mapped directly
Date: Fri, 25 Sep 2009 02:17:20 +0100
Message-ID: <9095.1253841440@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> And what are your opinions on the -stable desirability?

I think that it would be a good idea to add it to stable.

David
