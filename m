Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYL3QmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYL3QmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 11:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYL3Ql6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 11:41:58 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39329 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYL3Ql5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 11:41:57 -0500
Date: Tue, 30 Dec 2008 11:39:48 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, kamalesh@linux.vnet.ibm.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] clean up of netif_rx_reschedule() changes in drivers
Message-ID: <20081230163948.GB2701@localhost.localdomain>
References: <20081229102509.GA11111@linux.vnet.ibm.com> <20081229214144.43be8c1d.sfr@canb.auug.org.au> <20081229153757.GA2857@localhost.localdomain> <20081229.181908.214463121.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229.181908.214463121.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 06:19:08PM -0800, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Mon, 29 Dec 2008 10:37:57 -0500
> 
> > On Mon, Dec 29, 2008 at 09:41:44PM +1100, Stephen Rothwell wrote:
> > > Hi Kamalesh,
> > > 
> > > On Mon, 29 Dec 2008 15:55:29 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > > > greping through the sources for the changes missed out, we have
> > > > 
> > > 	.
> > > 	.
> > > > 
> > > > Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>  ...
> > Thanks guys, not sure how my patch missed that.  I did an allmodconfig build
> > that passed successfully.  Thanks!
> 
> It's very simple, you're not building on powerpc or ARM :-)
> 
Doh!  Stupid of me.  apologies.

> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Applied, thanks everyone.
> 
