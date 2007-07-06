Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbXGFW24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbXGFW24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbXGFW2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:28:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbXGFW2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:28:49 -0400
Date: Fri, 6 Jul 2007 15:28:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>, mel@csn.ul.ie
Subject: Re: [PATCH] memory unplug v7 [4/6] - page isolation
Message-Id: <20070706152828.9ae57453.akpm@linux-foundation.org>
In-Reply-To: <20070706182611.b16b6720.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
	<20070706182611.b16b6720.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007 18:26:11 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +/*
> + * start_isolate_page_range() -- make page-allocation-type of range of pages
> + * to be MIGRATE_ISOLATE.

I think kerneldoc requires that the above all be on a single line.
