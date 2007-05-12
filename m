Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbXELBDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbXELBDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 21:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXELBDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 21:03:05 -0400
Received: from loopy.telegraphics.com.au ([202.45.126.152]:49537 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbXELBDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 21:03:05 -0400
Date: Sat, 12 May 2007 11:03:00 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Simon Arlott <simon@fire.lp0.eu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, trival@kernel.org
Subject: Re: [PATCH] spelling fixes: arch/m68knommu/
In-Reply-To: <4644C716.1020000@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.64.0705121024480.14127@loopy.telegraphics.com.au>
References: <4644C716.1020000@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 May 2007, Simon Arlott wrote:

> - *	Local routines to interrcept the standard I/O and vector handling
> - *	code. Don't include this 'till now - initialization code above needs
> + *	Local routines to intercept the standard I/O and vector handling
> + *	code. Don't include this until now - initialization code above needs
>   *      access to the real code too.

What's wrong with 'til?

> - *	Sub-architcture dependant initialization code for the Freescale
> + *	Sub-architcture dependent initialization code for the Freescale

...

> - *	Sub-architcture dependant initialization code for the Freescale
> + *	Sub-architcture dependent initialization code for the Freescale

...

> - *	Sub-architcture dependant initialization code for the Motorola
> + *	Sub-architcture dependent initialization code for the Motorola

You want "Sub-architecture".

-f
