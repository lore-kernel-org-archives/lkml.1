Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbXETVQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbXETVQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbXETVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:16:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37932 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbXETVQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:16:35 -0400
Message-ID: <4650BAB7.9090403@cs.helsinki.fi>
Date: Mon, 21 May 2007 00:16:39 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 01/10] SLUB: add support for kmem_cache_ops
References: <20070518181040.465335396@sgi.com>  <20070518181118.828853654@sgi.com> <84144f020705190553s598e722fu7279253ee8b516bc@mail.gmail.com> <Pine.LNX.4.64.0705191119010.17008@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705191119010.17008@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Yeah earlier versions did this but then I have to do a patch that changes 
> all destructors and all kmem_cache_create calls in the kernel.

Yes, please ;-)


