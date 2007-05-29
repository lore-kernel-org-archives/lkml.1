Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbXE2NEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbXE2NEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbXE2NEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:04:36 -0400
Received: from loopy.telegraphics.com.au ([202.45.126.152]:54496 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXE2NEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:04:35 -0400
Date: Tue, 29 May 2007 23:04:33 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: stuff ready to be deleted?
In-Reply-To: <Pine.LNX.4.64.0705290953420.4790@anakin>
Message-ID: <Pine.LNX.4.64.0705292251520.13721@loopy.telegraphics.com.au>
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
 <Pine.LNX.4.64.0705290953420.4790@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Geert Uytterhoeven wrote:

> On Mon, 28 May 2007, Robert P. J. Day wrote:
> >   i'm trying to keep track of kernel janitor projects that involve
> > removing dead content from the tree:
> > 
> > http://fsdev.net/wiki/index.php?title=Kernel_Janitor%27s_Todo_List
> > 
> > currently, the list contains the items:
> 
>     [...]
> 
> >     * 11 Macintosh M68K support
> 
> It's not that because Mac/m68k went skipped 2.4.x that it should be removed...

It is true that the MAINTAINERS file is out of date. I suggest we remove 
the maintainers file ;-)

-f
