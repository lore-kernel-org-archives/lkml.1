Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYGGWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYGGWsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYGGWsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:48:09 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41727 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYGGWsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:48:08 -0400
Date: Mon, 7 Jul 2008 18:47:58 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Hugh Dickins <hugh@veritas.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] FS: Label tmpfs Kconfig option with "tmpfs".
In-Reply-To: <Pine.LNX.4.64.0807072231160.1608@blonde.site>
Message-ID: <alpine.LFD.1.10.0807071846520.9951@localhost.localdomain>
References: <alpine.LFD.1.10.0807071517090.29975@localhost.localdomain> <Pine.LNX.4.64.0807072231160.1608@blonde.site>
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

On Mon, 7 Jul 2008, Hugh Dickins wrote:

> On Mon, 7 Jul 2008, Robert P. J. Day wrote:
> >
> > Make it clear that the Kconfig option refers to "tmpfs".
> >
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
>
> It's so long since I used anything but "make oldconfig", which
> already shows TMPFS, making your mod seem redundant.  But you're right,
> menuconfig and xconfig don't show it, so your change is a good one.
>
> Though for the moment I can only give you
> acked-by: hugh dickins <hugh@veritas.com>:
> the next entry is for "Tmpfs POSIX Access Control Lists"
> so I'd rather you say "Tmpfs support (virtual memory file system)",
> then you can uppercase my ack.

or i could change the next line to read "tmpfs" rather than "Tmpfs".
:-)  does anyone have any strong feelings either way?

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
