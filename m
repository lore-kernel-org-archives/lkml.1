Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbXESW2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbXESW2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761647AbXESW2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:28:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59476 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760934AbXESW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:28:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464F79DA.7070808@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 00:27:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/5] 2.6.22-rc2: known regressions
References: <464F6DC9.80805@googlemail.com> <464F74C4.5070404@googlemail.com>
In-Reply-To: <464F74C4.5070404@googlemail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Memory management

> Subject    : BUG: at mm/slab.c:777 __find_general_cachep()
> References : http://lkml.org/lkml/2007/5/18/17
> Submitter  : Jeff Garzik <jeff@garzik.org>
> Status     : Unknown

Patch available and verified: http://lkml.org/lkml/2007/5/18/19
"avoid-zero-size-allocation-in-cache_k8_northbridges"

Category is x86-64, not memory management.
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
