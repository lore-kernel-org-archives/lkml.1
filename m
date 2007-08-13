Return-Path: <linux-kernel-owner+w=401wt.eu-S968486AbXHMTWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968486AbXHMTWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944904AbXHMTVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:21:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44113 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943660AbXHMTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:21:13 -0400
Date: Mon, 13 Aug 2007 21:21:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Satyam Sharma <satyam@infradead.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
 scripts/get_maintainer.pl
In-Reply-To: <alpine.LFD.0.999.0708132351320.29609@enigma.security.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0708132120520.30582@fbirervta.pbzchgretzou.qr>
References: <1186984174.10249.7.camel@localhost>  <200708131933.10125.m.kozlowski@tuxland.pl>
 <1187026955.2688.4.camel@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0708132351320.29609@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 14 2007 00:02, Satyam Sharma wrote:
>
>Better solution is to have multiple MAINTAINERS files distributed in the
>kernel tree, IMHO -- say a drivers/net/MAINTAINERS for maintainer info on
>all various net drivers, drivers/kvm/MAINTAINERS for KVM maintainer info,
>fs/ext3/MAINTAINERS for ext3 maintainers, fs/MAINTAINERS for generic VFS
>maintainers info, so on and so forth. Of course, these individual
>MAINTAINERS files could still have the newly-introduced "F:" fields as
>well (drivers/net/MAINTAINERS would clearly require it, f.e.) ...

Yes please.

Or perhaps even putting the maintainer into the Kconfig files?


	Jan
-- 
