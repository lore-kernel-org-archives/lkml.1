Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049Ab0AKLbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab0AKLbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 06:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824Ab0AKLbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 06:31:18 -0500
Received: from borg.medozas.de ([188.40.89.202]:55723 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0AKLbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 06:31:17 -0500
Date: Mon, 11 Jan 2010 12:31:16 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Joe Perches <joe@perches.com>
cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH V2] MAINTAINERS: netfilter - Document netfilter and
 netfilter-core lists purposes
In-Reply-To: <1263209269.1907.61.camel@Joe-Laptop.home>
Message-ID: <alpine.LSU.2.01.1001111229460.26235@obet.zrqbmnf.qr>
References: <cover.1262726222.git.joe@perches.com>  <bccf36219f3ea5a9b7565734bc87095bc986dbe0.1262726222.git.joe@perches.com>  <1262805798.1952.105.camel@Joe-Laptop.home>  <4B4B02BE.5060209@trash.net>  <1263208183.1907.50.camel@Joe-Laptop.home> 
 <4B4B0806.40801@trash.net> <1263209269.1907.61.camel@Joe-Laptop.home>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-01-11 12:27, Joe Perches wrote:

>Adding "subscribers-only" after the list address stops
>scripts/get_maintainer.pl from including the address
>unless --s is used.  Doesn't matter if the list really
>is subscribers-only or not.
>
>Signed-off-by: Joe Perches <joe@perches.com>
>
>+++ b/MAINTAINERS
>@@ -3742,8 +3742,8 @@ P:	Harald Welte
> P:	Jozsef Kadlecsik
> M:	Patrick McHardy <kaber@trash.net>
> L:	netfilter-devel@vger.kernel.org
>-L:	netfilter@vger.kernel.org
>-L:	coreteam@netfilter.org
>+L:	netfilter@vger.kernel.org	for user issues, not subscribers-only
>+L:	coreteam@netfilter.org		for private emails, not subscribers-only
> W:	http://www.netfilter.org/

This is a little stab-through-the-back -
rather than "subscribers-only", I'd use "subscriber-free" or FFA,
or just leave it blank and use "subscribers-only" instead
for these.

 L: netfilter-devel@vger.kernel.org
 L: coreteam@netfilter.org	subscribers-only

> W:	http://www.iptables.org/

netfilter.org/

