Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbXEJNQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbXEJNQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXEJNQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:16:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56605 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbXEJNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:16:49 -0400
Date: Thu, 10 May 2007 16:16:48 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
In-Reply-To: <20070510140452.25ae6765@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0705101606130.22625@sbz-30.cs.Helsinki.FI>
References: <20070510015555.973107048@polymtl.ca> <20070510020917.172554217@polymtl.ca>
 <20070510065847.GE8019@infradead.org> <20070510124120.6e8ac5aa@the-village.bc.nu>
 <20070510114158.GA16741@infradead.org> <20070510134816.5e57e3cb@the-village.bc.nu>
 <84144f020705100552u3f988e80u29fc412737522259@mail.gmail.com>
 <20070510140452.25ae6765@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Alan Cox wrote:
> Because people want to know what it is really for ? It's quite amazing
> really at the same time as people are posting crypto keys everywhere in
> defiance of USSA law, we've got free software people trying to remove
> references to a piece of out of tree software, and one that is free
> software. 

Oh, I am not advocating censorship. I was merely pointing out that it 
seems silly to mention out-of-tree users because they come and go. Who 
knows whether LTTng or SystemTAP will be relevant five years from now? 
Besides, are we sure the document includes all potential users now? We 
wouldn't want to show favorism to any particular projects, now would we?

On Thu, 10 May 2007, Alan Cox wrote: 
> And as I keep saying the tree is full of references to out of tree stuff.
> The documentation directory alone currently contains over a thousand http
> URLS as of 2.6.21-rc6-mm1.

Many of the already out of date or expiring in the near future... But 
whatever, I don't care too much. Just wanted to say the review comment 
makes sense to me.

				Pekka
