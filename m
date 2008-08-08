Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYHHQzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYHHQzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYHHQzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:55:40 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:58147 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYHHQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:55:40 -0400
Date: Fri, 8 Aug 2008 12:53:57 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: worth separating serial from parallel ATA kernel options?
In-Reply-To: <20080808172629.232bed01@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0808081251590.11996@localhost.localdomain>
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain> <20080808172629.232bed01@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Alan Cox wrote:

> On Fri, 8 Aug 2008 12:32:23 -0400 (EDT)
> "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
>
> >
> >   asked from a position of appalling ignorance, but would it be more
> > organized to be able to select serial ATA functionality separately
> > from parallel ATA?
>
> The correct fix is to remove the (experimental) from the Parallel
> ATA drivers Kconfig
>
> For the rest of the menu the list is SATA first, then PATA (and PATA
> is roughly alphabetic but both want a tidy)

  that definitely sounds like a job for the real ATA people.  i'll
leave it to them.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
