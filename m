Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbXFLACk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbXFLACk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXFLACa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:02:30 -0400
Received: from lazybastard.de ([212.112.238.170]:42645 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbXFLAC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:02:29 -0400
Date: Tue, 12 Jun 2007 01:57:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 10/18] fs/logfs/inode.c
Message-ID: <20070611235739.GB5377@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <200706101924.29927.arnd@arndb.de> <20070611232803.GA5377@lazybastard.org> <200706120151.36520.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706120151.36520.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 June 2007 01:51:34 +0200, Arnd Bergmann wrote:
> On Tuesday 12 June 2007, Jörn Engel wrote:
> > The initial storm of review comments has calmed down.  I get the
> > impression that people either lose interest or run out of simple things
> > to point out.  Maybe I should wait a bit before resending?
> 
> Your last series had a todo list of 11 items, plus more stuff
> found in the review. How about you submit logfs for inclusion in -mm
> when all easy stuff is gone from that list?

I was hoping to get more comments still.  But maybe your are right.
Half of your last comments looked more like test reports than code
review.

Jörn

-- 
Linux is more the core point of a concept that surrounds "open source"
which, in turn, is based on a false concept. This concept is that
people actually want to look at source code.
-- Rob Enderle
