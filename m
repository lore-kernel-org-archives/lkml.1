Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0CEMHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:07:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35511 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275Ab0CEMH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:07:29 -0500
Date: Fri, 5 Mar 2010 12:07:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: torvalds@osdl.org, akpm@osdl.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [git pull] more PCMCIA updates for 2.6.34 (including ioctl
 deprecation)
Message-ID: <20100305120746.646126b9@lxorguk.ukuu.org.uk>
In-Reply-To: <20100303083010.GA22928@flint.arm.linux.org.uk>
References: <20100303075944.GA23354@comet.dominikbrodowski.net>
	<20100303083010.GA22928@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So you believe that disabling the button in the graphical environment
> to allow PCMCIA cards to be removed (such as CF cards) - leaving the
> user to merely pull out the CF card, while the FS is mounted, is a
> good idea?

Do any graphical environments even support the ancient user space
pcmcica helper stuff ? I can't find any evidence they do but I realise
Russell you get to deal with assorted crazy ARM embedded setups.

Alan
