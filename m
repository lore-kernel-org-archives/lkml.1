Return-Path: <linux-kernel-owner+w=401wt.eu-S2992567AbXCWUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992567AbXCWUsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992572AbXCWUsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:48:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44475 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992567AbXCWUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:48:18 -0400
Date: Fri, 23 Mar 2007 21:51:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, kyle@canonical.com
Subject: Re: HPA patches
Message-ID: <20070323215140.6a79868c@lxorguk.ukuu.org.uk>
In-Reply-To: <20070323.122232.85421062.davem@davemloft.net>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
	<20070323112411.f6a8a762.randy.dunlap@oracle.com>
	<20070323200819.4e734f4f@lxorguk.ukuu.org.uk>
	<20070323.122232.85421062.davem@davemloft.net>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 12:22:32 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Fri, 23 Mar 2007 20:08:19 +0000
> 
> > u64 is always unsigned long long (and its debug anyway)
> 
> It's plain "unsigned long" on sparc64 and some other 64-bit platforms.

I stand corrected. In which case Randy is right and I do need to go fix
that formatting.

Thanks

Alan
