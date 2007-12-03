Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbXLCAUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbXLCAUO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 19:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXLCAT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 19:19:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48992 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbXLCAT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 19:19:58 -0500
Date: Mon, 3 Dec 2007 00:14:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davids@webmaster.com
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Mark Lord" <lkml@rtr.ca>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, "Greg KH" <greg@kroah.com>,
       "Tejun Heo" <htejun@gmail.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       <netdev@vger.kernel.org>, <cornelia.huck@de.ibm.com>,
       <stern@rowland.harvard.edu>, <kay.sievers@vrfy.org>,
       <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "David Miller" <davem@davemloft.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: namespace support requires network modules to say "GPL"
Message-ID: <20071203001441.02cd6f2a@the-village.bc.nu>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEDMIJAC.davids@webmaster.com>
References: <20071201192341.6750fbdb@the-village.bc.nu>
	<MDEHLPKNGKAHNMBLJOLKGEDMIJAC.davids@webmaster.com>
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

> You license yours under the GPL, so they should respect the GPL.
> 
> It sounds like we're back to where we were years ago. Didn't we already
> agree that EXPORT_SYMBOL_GPL was *NOT* a GPL-enforcement mechanism and had
> nothing to do with respecting the GPL? After all, if it s a GPL-enforcement

No we seem to be back recycling the fact that certain people were making
statements that might be construed, unanswered, as giving permission to
violate the GPL.

I'm merely reminding people that I've not waived my GPL rights, I've not
said modules are somehow magically OK, and I don't agree with Linus. 

The GPL very clearly says that you can make your own unredistributed
modifications and keep them that way.

Alan
