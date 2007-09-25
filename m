Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbXIYHKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbXIYHKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXIYHKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:10:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60396 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXIYHKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:10:22 -0400
Date: Tue, 25 Sep 2007 09:10:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
cc: "Robert P. J. Day" <rpjday@mindspring.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.7 autoconf.h is screwed up
In-Reply-To: <3f9a31f40709240355t52e536a2u833fea747f074382@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709250907580.23305@fbirervta.pbzchgretzou.qr>
References: <3f9a31f40709240320mb213a7an87cee8bf5517d7f7@mail.gmail.com> 
 <Pine.LNX.4.64.0709240625140.31104@localhost.localdomain> 
 <3f9a31f40709240335w441699b5y366211baeebde871@mail.gmail.com> 
 <Pine.LNX.4.64.0709240637140.791@localhost.localdomain> 
 <3f9a31f40709240346o21eb48b8u518a1af72faa9e8f@mail.gmail.com> 
 <Pine.LNX.4.64.0709240647140.1295@localhost.localdomain>
 <3f9a31f40709240355t52e536a2u833fea747f074382@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 24 2007 16:25, Jaswinder Singh wrote:

>So it is obsolete for user's point of view, right ?

.config is human-readable and serves as input for kconfig,

and autoconf.h is kconfig's output for the C binding that
you do not mess with.

Neither is obsolete, end of story.

If Linux were to have Perl bindings, there would probably
be an autoconf.pl.
