Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYKPJYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYKPJYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYKPJYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:24:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37994
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbYKPJYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:24:10 -0500
Date: Sun, 16 Nov 2008 01:24:09 -0800 (PST)
Message-Id: <20081116.012409.120507131.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@blueteddy.net, daniel.blueman@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1L1dgo-0007pG-SL@gondolin.me.apana.org.au>
References: <20081104.145242.112948002.davem@davemloft.net>
	<E1L1dgo-0007pG-SL@gondolin.me.apana.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sun, 16 Nov 2008 17:13:06 +0800

> David Miller <davem@davemloft.net> wrote:
> >
> > This is because TSO, which is on by default, doesn't support ECN
> > in many implementations.
> 
> Dave, we fixed that ages ago.

I know, Michael Chan corrected me in a followup posting :)
