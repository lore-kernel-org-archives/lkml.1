Return-Path: <linux-kernel-owner+w=401wt.eu-S965215AbXFFXpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215AbXFFXpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966114AbXFFXmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:42:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966109AbXFFXms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:42:48 -0400
Date: Wed, 6 Jun 2007 16:42:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@gmx.de>
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606164202.a3dcd176.akpm@linux-foundation.org>
In-Reply-To: <20070606212831.GA1534@gondor.apana.org.au>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<200706062132.37430.m.kozlowski@tuxland.pl>
	<20070606132439.3f59f0cf.akpm@linux-foundation.org>
	<20070606212831.GA1534@gondor.apana.org.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 07:28:31 +1000 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Jun 06, 2007 at 01:24:39PM -0700, Andrew Morton wrote:
> >
> > > And for some reason the whole Cryptographic API is under the main level of menu 
> > > (please find .config and menu.png attached).
> > 
> > err, yes.  git-cryptodev.patch did that.  Herbert is being immodest ;)
> 
> Is it this patch?

looks like it.

> If so then you sent to it me :)

You merged it ;)

> Should I drop it?

Sure, Jan will fix it up, I assume.  I might have broken it while repairing
the reject storm which occurred when that durned HAS_IOMEM thing went in
all over the tree.


