Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbXDQNij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbXDQNij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXDQNij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:38:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52120 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754323AbXDQNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:38:38 -0400
Date: Tue, 17 Apr 2007 14:40:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       i4ldeveloper@listserv.isdn4linux.de, Karsten Keil <kkeil@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: so what *is* obsolete and removable?
Message-ID: <20070417144054.24c104bf@the-village.bc.nu>
In-Reply-To: <4624C320.3050206@imap.cc>
References: <Pine.LNX.4.64.0704151647200.29357@localhost.localdomain>
	<4623FB0E.4080602@imap.cc>
	<20070416161337.d59f2ea3.randy.dunlap@oracle.com>
	<4624C320.3050206@imap.cc>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > If the patch is in -mm and it's not critical (like this subject),
> > then it probably won't be merged until after 2.6.21 is released...
> 
> Fine by me, as long as it does get merged eventually so I can stop
> watching for attempts to remove isdn4linux as obsolete.

If the obsolete tag is to be removed then it needs a formal maintainer,
all the obsolete interface usage cleaning up and the like otherwise at
some point in a clean up it is going to end up breaking and migrating to
&& BROKEN as well.

If that is going to get done (by Karsten or someone else given Karsten
appears totally occupied on other stuff) then great.

Alan
