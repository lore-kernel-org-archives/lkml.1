Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbXHLGpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbXHLGpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 02:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbXHLGp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 02:45:28 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37490 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbXHLGp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 02:45:27 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 12 Aug 2007 02:39:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <rdunlap@xenotime.net>
cc: vincent.legoll@gmail.com, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Add "def_bool" Kconfig format documentation
In-Reply-To: <20070811220928.b079d2e5.rdunlap@xenotime.net>
Message-ID: <Pine.LNX.4.64.0708120238440.8506@localhost.localdomain>
References: <1186439380.21014.9.camel@quad> <20070811220928.b079d2e5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007, Randy Dunlap wrote:

> On Tue, 07 Aug 2007 00:29:40 +0200 Vincent Legoll wrote:
>
> > Hello,
> >
> > here is a small documentation patch for the KConfig file format
> > "def_bool" type definition that was missing.
>
> There are also def_boolean and def_tristate.

while the parser recognizes "def_boolean", it's not used anywhere in
the tree.  perhaps it can simply be dropped in favour of def_bool.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
