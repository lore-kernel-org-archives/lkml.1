Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbYGPQ1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbYGPQ1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbYGPQ1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:27:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:38146 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758813AbYGPQ1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:27:23 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1//iIhBHOP/WH3BskNTPBpa4r7pQF+8vvjWhsYRP5
	Oj4FWE5J8mNuBI
Date: Wed, 16 Jul 2008 18:27:20 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] proc: fix /proc/*/pagemap some more
Message-ID: <20080716162720.GB23096@alice>
References: <20080716152025.GA23096@alice> <20080716153628.GA5795@martell.zuzino.mipt.ru> <20080716155947.GA4809@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080716155947.GA4809@martell.zuzino.mipt.ru>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26 (x86_64)
X-Uptime: 18:27:03 up 10:43,  1 user,  load average: 0.07, 0.16, 0.39
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Wed, Jul 16, 2008 at 07:36:28PM +0400, Alexey Dobriyan wrote:
> > On Wed, Jul 16, 2008 at 05:20:25PM +0200, Eric Sesterhenn wrote:
> > > with current -git a "cat /proc/4260/pagemap"
> > > gives me the following oops:
> > 
> > reproduced
> 
> Oh, wow!
> 
> [PATCH] proc: fix /proc/*/pagemap some more

thanks, the patch fixes the issue for me

Greetings, Eric
