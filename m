Return-Path: <linux-kernel-owner+w=401wt.eu-S932935AbXGXU4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbXGXU4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932752AbXGXU4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:56:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59225 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742AbXGXU4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:56:23 -0400
Message-ID: <46A66774.3070702@garzik.org>
Date: Tue, 24 Jul 2007 16:56:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_hpt37x: Fix 2.6.22 clock PLL regression
References: <20070724151748.7e99f4f0@the-village.bc.nu>
In-Reply-To: <20070724151748.7e99f4f0@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 	Just one version of Linux ago
> 	The PLL code broke - oh no!
> 	But set the right mode
> 	And fix up the code
> 	Makes the PLL timing sync go
> 
> Closes-bug: #8791
> Signed-off-by: Alan Cox <alan@redhat.com>

applied


