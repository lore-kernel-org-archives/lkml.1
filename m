Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbXKLKzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbXKLKzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbXKLKy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:54:58 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:33528 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbXKLKy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:54:58 -0500
Date: Mon, 12 Nov 2007 05:51:54 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Andreas Schwab <schwab@suse.de>
cc: Jan Engelhardt <jengelh@computergmbh.de>, axboe@kernel.dk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Include header required for INT_MAX
In-Reply-To: <jeabpj3fn1.fsf@sykes.suse.de>
Message-ID: <alpine.LFD.0.9999.0711120551380.23072@localhost.localdomain>
References: <Pine.LNX.4.64.0711112349580.15517@fbirervta.pbzchgretzou.qr> <jeabpj3fn1.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007, Andreas Schwab wrote:

> Jan Engelhardt <jengelh@computergmbh.de> writes:
>
> > No, because I be damn sure that some developers try compiling programs
> > in non-linux environments (cygwin, solaris, andyourpersonaldistro, you
> > name it) which do not have to adhere to <limits.h>. It might use
> > <cosmiclimits.h> instead, or whatever.
>
> Every C compiler has <limit.h>.

i'm assuming you mean <limits.h>, no?

rday
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
