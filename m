Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbXEJLh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbXEJLh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbXEJLhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:37:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58792 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754069AbXEJLht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:37:49 -0400
Date: Thu, 10 May 2007 12:41:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 07/10] Linux Kernel Markers - Documentation
Message-ID: <20070510124120.6e8ac5aa@the-village.bc.nu>
In-Reply-To: <20070510065847.GE8019@infradead.org>
References: <20070510015555.973107048@polymtl.ca>
	<20070510020917.172554217@polymtl.ca>
	<20070510065847.GE8019@infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 07:58:47 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, May 09, 2007 at 09:56:02PM -0400, Mathieu Desnoyers wrote:
> > Here is some documentation explaining what is/how to use the Linux
> > Kernel Markers.
> 
> Please remove all references to out of tree code from the kernel documentation.

Christoph stop being ridiculous. Its one thing to object to kernel
markers and some of the rather nice tools they give you for
borderline technical reasons, but at the point you start saying "remove
references to" you are just trying to censor stuff you don't personally
approve of and you sound as stupid as RMS in his "don't link to non GPL
material" mode.

The kernel documentation is *FULL* of references to out of tree code and
documents precisely because the kernel does not exist in isolation. 

Alan
