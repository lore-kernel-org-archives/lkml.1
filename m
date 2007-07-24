Return-Path: <linux-kernel-owner+w=401wt.eu-S934828AbXGXJHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828AbXGXJHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761783AbXGXJG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:06:56 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41917 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760092AbXGXJGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:06:55 -0400
Message-ID: <46A5C105.20707@s5r6.in-berlin.de>
Date: Tue, 24 Jul 2007 11:06:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de, clameter@sgi.com,
       cornelia.huck@de.ibm.com, davem@davemloft.net, greg@kroah.com,
       hch@infradead.org, rientjes@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/10] try parent numa_node at first before using default
 v2
References: <200707231323.57502.yinghai.lu@sun.com>
In-Reply-To: <200707231323.57502.yinghai.lu@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/2007 10:23 PM, Yinghai Lu wrote:
> this one already in -mm, but it needs [PATCH 1/10]
> 
> [PATCH 3/10] try parent numa_node at first before using default v2
[...]
> this patch is using second method.
[...]

Could you shorten the patch description?

Don't describe what your patch _does not_ do.  Don't even describe _how_
your patch does what it does (unless it's obfuscated, but then that
would be a bad patch anyway).

Just describe _why_ it does something.
-- 
Stefan Richter
-=====-=-=== -=== ==---
http://arcgraph.de/sr/
