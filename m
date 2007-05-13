Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbXEMNIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbXEMNIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 09:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759813AbXEMNIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 09:08:23 -0400
Received: from main.gmane.org ([80.91.229.2]:38158 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759803AbXEMNIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 09:08:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jindrich Makovicka <makovick@gmail.com>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Date: Sun, 13 May 2007 15:06:34 +0200
Message-ID: <20070513150634.2b7ba461@holly>
References: <1783772957@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: kmlinux.fjfi.cvut.cz
In-Reply-To: <1783772957@web.de>
X-Newsreader: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 22:48:15 +0200
devzero@web.de wrote:

> >Why is this needed?  What code plans to use it?
> 
> it`s pretty useful because it`s and a damn fast and damn cpu friendly
> compression alorithm.
> 
> afaik, there is already a least one linux kernel-feature (under
> development) which is using lzo compression: see compressed caching
> project at http://linux-mm.org/CompressedCaching &
> http://linuxcompressed.sourceforge.net/

Reiser4.1 (still in development) uses LZO compression too and it brings
a significant boost on dual core machines.

-- 
Jindrich Makovicka

