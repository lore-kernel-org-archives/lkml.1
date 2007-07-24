Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbXGXUiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbXGXUiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764152AbXGXUhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:37:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59027 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762345AbXGXUht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:37:49 -0400
Message-ID: <46A662FE.3050001@pobox.com>
Date: Tue, 24 Jul 2007 16:37:18 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] defxx: Use __maybe_unused rather than a local hack
References: <Pine.LNX.4.64N.0707201310060.7402@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0707201310060.7402@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>  This is a change to remove a local hack in favour to __maybe_unused that 
> has been recently added.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
> Hi,
> 
>  It should be obvious.  The code builds, therefore it works.
> 
>  Please apply,
> 
>   Maciej
> 

applied


