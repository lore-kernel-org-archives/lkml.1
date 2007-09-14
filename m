Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbXINBCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbXINBCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 21:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXINBCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 21:02:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045AbXINBCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 21:02:12 -0400
Date: Thu, 13 Sep 2007 18:01:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/13] Reduce external fragmentation by grouping pages by
 mobility v30
Message-Id: <20070913180156.ee0cdec4.akpm@linux-foundation.org>
In-Reply-To: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 12:20:11 +0100 (IST) Mel Gorman <mel@csn.ul.ie> wrote:

> Here is a restacked version of the grouping pages by mobility patches
> based on the patches currently in your tree. It should be  a drop-in
> replacement for what is in 2.6.23-rc4-mm1 and is what I propose for merging
> to mainline.

It really gives me the creeps to throw away a large set of large patches
and to then introduce a new set.

What would go wrong if we just merged the patches I already have?
