Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbXF1KZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbXF1KZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXF1KZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:25:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35784 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754718AbXF1KZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:25:05 -0400
Date: Thu, 28 Jun 2007 11:23:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: casey@schaufler-ca.com
Cc: David Miller <davem@davemloft.net>, crispin@novell.com,
       seanlkml@sympatico.ca, bunk@stusta.de, akpm@linux-foundation.org,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070628112324.4621b650@the-village.bc.nu>
In-Reply-To: <350078.43404.qm@web36601.mail.mud.yahoo.com>
References: <20070627.160535.71552808.davem@davemloft.net>
	<350078.43404.qm@web36601.mail.mud.yahoo.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Anyone can apply the apparmour patch to their tree, they get the
> > choice that way.  Nobody is currently prevented from using apparmour
> > if they want to, any such suggestion is pure rubbish.
> 
> The exact same argument was made prior to SELinux going upstream.

Its made for every thing before it goes upstream. It shouldn't be going
uptream until it works, is reliable and does something useful. Then if it
ever makes that grade it can go and sit in -mm for a bit to shake down .

> > Frankly I think AppArmour is a joke,
> 
> "SELinux, AppArmor, and Hilary Clinton walk into a bar ..."


SELinux orders a beer object
AppArmor order a /beer
Hilary says "You are both under 21 you can't"
SELinux orders a shandy object
AppArmor orders a /shandy

SELinux is refused because the shandy mixer opened a beer object and
	shandy inherited beer typing
AppArmor gets drunk because /shandy and /beer are clearly different


