Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXLAT2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXLAT2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 14:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXLAT2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 14:28:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48268 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752731AbXLAT2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 14:28:20 -0500
Date: Sat, 1 Dec 2007 19:23:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: namespace support requires network modules to say "GPL"
Message-ID: <20071201192341.6750fbdb@the-village.bc.nu>
In-Reply-To: <20071201111736.297dd99a@freepuppy.rosehill>
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	<47515D39.9030900@rtr.ca>
	<20071201111736.297dd99a@freepuppy.rosehill>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then init_net needs to be not GPL limited. Sorry, we need to allow
> non GPL network drivers.  There is a fine line between keeping the

Why - they aren't exactly likely to be permissible by law

> binary seething masses from accessing random kernel functions, and allowing
> reasonable (but still non GPL) things like ndiswrapper to use network
> device interface.

Its up to the ndiswrapper authors how the licence their code, but they
should respect how we licence ours.
