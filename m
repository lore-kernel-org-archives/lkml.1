Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116Ab0AKLny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0AKLny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 06:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485Ab0AKLnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 06:43:53 -0500
Received: from mail.perches.com ([173.55.12.10]:1062 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab0AKLnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 06:43:52 -0500
Subject: Re: [PATCH V2] MAINTAINERS: netfilter - Document netfilter and
 netfilter-core lists purposes
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <alpine.LSU.2.01.1001111229460.26235@obet.zrqbmnf.qr>
References: <cover.1262726222.git.joe@perches.com>
	 <bccf36219f3ea5a9b7565734bc87095bc986dbe0.1262726222.git.joe@perches.com>
	 <1262805798.1952.105.camel@Joe-Laptop.home>  <4B4B02BE.5060209@trash.net>
	 <1263208183.1907.50.camel@Joe-Laptop.home>  <4B4B0806.40801@trash.net>
	 <1263209269.1907.61.camel@Joe-Laptop.home>
	 <alpine.LSU.2.01.1001111229460.26235@obet.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 03:43:50 -0800
Message-ID: <1263210230.1907.72.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 12:31 +0100, Jan Engelhardt wrote:
> On Monday 2010-01-11 12:27, Joe Perches wrote:
> >Adding "subscribers-only" after the list address stops
> >scripts/get_maintainer.pl from including the address
> >unless --s is used.  Doesn't matter if the list really
> >is subscribers-only or not.

> This is a little stab-through-the-back -
> rather than "subscribers-only", I'd use "subscriber-free" or FFA,
> or just leave it blank and use "subscribers-only" instead
> for these.

You're welcome and free to change the script
and MAINTAINERS.

I think this works well-enough though.

cheers, Joe

