Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbZADVzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbZADVzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbZADVzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:55:32 -0500
Received: from thunk.org ([69.25.196.29]:57202 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152AbZADVza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:55:30 -0500
Date: Sun, 4 Jan 2009 16:55:19 -0500
From: Theodore Tso <tytso@mit.edu>
To: Duane Griffin <duaneg@dghda.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104215519.GC22958@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Duane Griffin <duaneg@dghda.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>, Valdis.Kletnieks@vt.edu,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <495FF9CE.2020908@ribosome.natur.cuni.cz> <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com> <495FFECB.5040001@ribosome.natur.cuni.cz> <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com> <15786.1231041158@turing-police.cc.vt.edu> <e9e943910901040624y69c01b43p1655c0078b969ea6@mail.gmail.com> <20090104184040.GC17558@mit.edu> <Pine.LNX.4.64.0901042015230.31141@anakin> <20090104193637.GB22958@mit.edu> <e9e943910901041151x4f251224w63df1e6237ec48cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e943910901041151x4f251224w63df1e6237ec48cb@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 07:51:27PM +0000, Duane Griffin wrote:
> 
> If anyone is interested I'd be happy to dust off and send them my old
> patches to implement this. There are a couple of issues with it.
> First, I never got around to implementing remount R/W support. Second,
> I had to introduce a rather nasty hack in order to handle un-escaping
> JFS magic numbers.

Can you dust off the patches and send a copy to
linux-ext4@vger.kernel.org so we have them archived someplace where
hopefully someone might have time to look at it?

	  	  	     	     	  - Ted
