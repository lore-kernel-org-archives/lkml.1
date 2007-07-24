Return-Path: <linux-kernel-owner+w=401wt.eu-S1760331AbXGXXH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331AbXGXXH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbXGXXHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:07:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492AbXGXXHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:07:48 -0400
Date: Tue, 24 Jul 2007 16:07:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] pata_hpt37x: Fix 2.6.22 clock PLL regression
In-Reply-To: <20070724151748.7e99f4f0@the-village.bc.nu>
Message-ID: <alpine.LFD.0.999.0707241607150.3607@woody.linux-foundation.org>
References: <20070724151748.7e99f4f0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, Alan Cox wrote:
> 
> 	Just one version of Linux ago
> 	The PLL code broke - oh no!
> 	But set the right mode
> 	And fix up the code
> 	Makes the PLL timing sync go

Alan, I'm getting a bit worried about you.

		Linus
