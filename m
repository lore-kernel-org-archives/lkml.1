Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbXGABxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbXGABxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 21:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbXGABxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 21:53:00 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1413 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbXGABxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 21:53:00 -0400
Date: Sun, 1 Jul 2007 03:53:08 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
In-Reply-To: <20070630143914.029ce2a7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707010350220.1818@scrub.home>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
 <6150.1183128630@turing-police.cc.vt.edu> <20070629140130.59d58c44.akpm@linux-foundation.org>
 <15437.1183177066@turing-police.cc.vt.edu> <20070629221510.95c4c8e1.akpm@linux-foundation.org>
 <20070630211017.GA26234@uranus.ravnborg.org> <20070630143914.029ce2a7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 30 Jun 2007, Andrew Morton wrote:

> > > I continue to believe that kbuild's lets-trash-your-symlink behaviour is
> > > obnoxious, but I was unable to persuade anyone else of this.
> >
> > I thought we fixed that long time ago?!?!
> 
> Nope, a simple `make oldconfig' breaks the symlink.

KCONFIG_OVERWRITECONFIG was added especially for you. :-)

bye, Roman
