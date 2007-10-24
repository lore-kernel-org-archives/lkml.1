Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXJXHg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXJXHg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXJXHgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:36:51 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35227 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbXJXHgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:36:50 -0400
Date: Wed, 24 Oct 2007 16:36:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       linuxsh-shmedia-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh64: fix dma_cache_sync() compilation
Message-ID: <20071024073629.GA17547@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
	linuxsh-shmedia-dev@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20071022024730.GH30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022024730.GH30533@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 04:47:30AM +0200, Adrian Bunk wrote:
> This patch fixes the following compile error caused by
> commit 622a9edd919de98ef59571ae6c40c7458244e3f2:
> 
Applied, thanks Adrian.
