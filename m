Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbYJIWK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbYJIWK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 18:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYJIWKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 18:10:20 -0400
Received: from 1wt.eu ([62.212.114.60]:4688 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbYJIWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 18:10:19 -0400
Date: Fri, 10 Oct 2008 00:09:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Davi Leal <davi@leals.com>, linux-kernel@vger.kernel.org,
       gnuherds-app-dev@nongnu.org
Subject: Re: free tg3 ethernet driver
Message-ID: <20081009220904.GK24654@1wt.eu>
References: <200810082353.31033.davi@leals.com> <20081008230827.6e1423fe@lxorguk.ukuu.org.uk> <200810092236.58534.davi@leals.com> <20081009225143.7999311d@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009225143.7999311d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 10:51:43PM +0100, Alan Cox wrote:
> On Thu, 9 Oct 2008 22:36:57 +0200
> Davi Leal <davi@leals.com> wrote:
> 
> > Alan Cox wrote:
> > > Well if you want to write new firmware for the device you'll need to
> > > reverse engineer the chip internals or convince Broadcom to document them
> > > for you. I suspect you'll have to get to the point of xraying the
> > > component slice by slice and need a multi-million dollar budget.
> > 
> > People position seem to be continue to pledge to pay $151 to the developer(s) 
> > (even if it's Broadcom in case they apply to the pledge system) who provide a 
> > free driver for tg3 devices.
> 
> Well thats good, another 1.999849 million dollars and you might get
> started.
> 
> With the best will in the world if you go and pay Broadcom zillions to
> open source the firmware the only incentive you create is for them to
> keep future firmware proprietary to sell to you next time around.

Very true. If I start cooking awful cakes and I see people come to pay
me for throwing them away, I'll sure restart ASAP.

> If on the other hand you buy non Broadcom equipment if you feel this
> way about the firmware then you create a far better economic incentive,
> and at $10 a NIC its not really hard to do that.

And that's not counting with the fact that their crappy BNX2 has been
showing horrible performance for several years now on servers, dropping
frames like mad, and reminding the poor reliability and performance of
Dlink's DL2000...

Willy

