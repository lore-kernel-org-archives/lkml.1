Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbXEJLpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbXEJLpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761414AbXEJLme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:42:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50966 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761402AbXEJLmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:42:33 -0400
Date: Thu, 10 May 2007 12:41:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
Message-ID: <20070510114158.GA16741@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070510015555.973107048@polymtl.ca> <20070510020917.172554217@polymtl.ca> <20070510065847.GE8019@infradead.org> <20070510124120.6e8ac5aa@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510124120.6e8ac5aa@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:41:20PM +0100, Alan Cox wrote:
> On Thu, 10 May 2007 07:58:47 +0100
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Wed, May 09, 2007 at 09:56:02PM -0400, Mathieu Desnoyers wrote:
> > > Here is some documentation explaining what is/how to use the Linux
> > > Kernel Markers.
> > 
> > Please remove all references to out of tree code from the kernel documentation.
> 
> Christoph stop being ridiculous. Its one thing to object to kernel
> markers

I do not object kernel markers, and I have no idea where you got
that crap from.  Quite contrary I've worked with Matthew on
getting both markers and lttng good enough that we can merge
it eventually.

Documentation of kernel facilities should not mention big outside
blobs of crap nerverless, which is something totally different from
not mentionining userspace code contrary to your ill-advised position.
