Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbYG0Rj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbYG0Rj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 13:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYG0RjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 13:39:18 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:58116
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750840AbYG0RjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 13:39:17 -0400
Date: Sun, 27 Jul 2008 13:39:18 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: "Karsten Keil" <kkeil@suse.de>, "ppc-dev" <linuxppc-dev@ozlabs.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-ID: <20080727133918.72cbb127@lappy.seanm.ca>
In-Reply-To: <20080728023732.090aff83.sfr@canb.auug.org.au>
References: <20080728023732.090aff83.sfr@canb.auug.org.au>
Organization: PIKA
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 02:37:32 +1000
"Stephen Rothwell" <sfr@canb.auug.org.au> wrote:

> On powerpc (allyesconfig build) we get this error:
> 
> drivers/isdn/hardware/mISDN/hfcpci.c:1991: error: implicit
> declaration of function 'virt_to_bus'

When did mISDN make it into the kernel? And which kernel tree is it in?
I don't see it in the Linux next tree....

I am very interested since we are trying to get mISDN working on the
Warp. There was no notice that they got 2.6.26 compiling.

Cheers,
   Sean
