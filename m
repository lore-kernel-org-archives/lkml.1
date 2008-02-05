Return-Path: <linux-kernel-owner+w=401wt.eu-S1763282AbYBEXbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763282AbYBEXbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762412AbYBEXbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:31:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34958 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758651AbYBEXbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:31:42 -0500
Date: Tue, 5 Feb 2008 23:25:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Diego Zuccato <diego@otello.alma.unibo.it>,
       David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080205232550.5d3d22ff@core>
In-Reply-To: <courier.47A8F072.000079E4@hawking.rebel.net.au>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D895.20300@davidnewall.com>
	<47A6E742.80408@otello.alma.unibo.it>
	<courier.47A8F072.000079E4@hawking.rebel.net.au>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "Of course", because in many parts of the world, a device who's manufacturer 
> fails to take reasonable steps to prevent it from being used outside 
> regulatory limits is illegal.  Providing source code not only is a failure 
> to take those reasonable steps, but is quite the opposite.  It may even be 
> viewed as encouraging users to use it inappropriately.

To my knowledge there is no caselaw on this for software, nor is it
clearly so simple - many vendors do provide source, many vendors provide
windows drivers where any end user can click to specify their country and
can lie trivially. Many users retrofit US firmware to non US devices and
its trivial to do. Its a hard problem - if I get on the train I can
change regulatory domain and wireless regulations mid trip. I'm not even
sure at what point the wireless rules are deemed to change between the UK
and France either - there isn't any caselaw for that ;)

Some (particularly US) companies choose to take a conservative view based
on their pessimistic reading of the intent of the US regulator plus the
ability of the regulator to do a lot of damage to their business.

The notion they are illegal is a real unknown and the market seems split
on views of this.

Alan
