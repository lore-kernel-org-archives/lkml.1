Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbXEJNBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbXEJNBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbXEJNAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:00:55 -0400
Received: from [81.2.110.250] ([81.2.110.250]:60269 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759615AbXEJNAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:00:54 -0400
Date: Thu, 10 May 2007 14:04:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
Message-ID: <20070510140452.25ae6765@the-village.bc.nu>
In-Reply-To: <84144f020705100552u3f988e80u29fc412737522259@mail.gmail.com>
References: <20070510015555.973107048@polymtl.ca>
	<20070510020917.172554217@polymtl.ca>
	<20070510065847.GE8019@infradead.org>
	<20070510124120.6e8ac5aa@the-village.bc.nu>
	<20070510114158.GA16741@infradead.org>
	<20070510134816.5e57e3cb@the-village.bc.nu>
	<84144f020705100552u3f988e80u29fc412737522259@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 15:52:26 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On 5/10/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > "blobs of crap" - in whose opinion. Yours. So you don't want the kernel
> > to mention things you personally don't approve of. Thats straight forward
> > censorship and has no place in free software.
> 
> Out of kernel code comes and goes, so why mention it in-tree? Besides,
> what's wrong with the suggested "can be used for tracing or
> performance accounting?"

Because people want to know what it is really for ? It's quite amazing
really at the same time as people are posting crypto keys everywhere in
defiance of USSA law, we've got free software people trying to remove
references to a piece of out of tree software, and one that is free
software. 

And as I keep saying the tree is full of references to out of tree stuff.
The documentation directory alone currently contains over a thousand http
URLS as of 2.6.21-rc6-mm1.

Alan
