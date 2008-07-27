Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbYG0Uo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbYG0Uo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 16:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbYG0UoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 16:44:18 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:37451 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbYG0UoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 16:44:18 -0400
Date: Sun, 27 Jul 2008 22:43:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, kkeil@suse.de, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-ID: <20080727204355.GA14057@uranus.ravnborg.org>
References: <20080728023732.090aff83.sfr@canb.auug.org.au> <20080727182709.1dac0556@lxorguk.ukuu.org.uk> <20080727.125604.73857337.davem@davemloft.net> <adamyk35aoi.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamyk35aoi.fsf@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 01:33:49PM -0700, Roland Dreier wrote:
>  > IMHO, this driver was really rushed in and that was a huge mistake.
>  > If it had gone through linux-next we could have tidied all of this
>  > stuff up in a less "rushed" manner.
> 
> ??  This thread *is* about a build failure in linux-next.
mISDN are in -linus which is part of -next and Stephens point is that if
we have had mISDN in -next then this would have been fixed before hitting
-linus. Maybe Karsten should use davem as gateway as he has anyway been
so for other isdn patches lately?

	Sam
