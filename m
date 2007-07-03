Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbXGCUhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbXGCUhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbXGCUhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:37:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583AbXGCUho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:37:44 -0400
Date: Tue, 3 Jul 2007 13:36:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
Message-Id: <20070703133650.20663702.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707010350220.1818@scrub.home>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<6150.1183128630@turing-police.cc.vt.edu>
	<20070629140130.59d58c44.akpm@linux-foundation.org>
	<15437.1183177066@turing-police.cc.vt.edu>
	<20070629221510.95c4c8e1.akpm@linux-foundation.org>
	<20070630211017.GA26234@uranus.ravnborg.org>
	<20070630143914.029ce2a7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707010350220.1818@scrub.home>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2007 03:53:08 +0200 (CEST)
Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Sat, 30 Jun 2007, Andrew Morton wrote:
> 
> > > > I continue to believe that kbuild's lets-trash-your-symlink behaviour is
> > > > obnoxious, but I was unable to persuade anyone else of this.
> > >
> > > I thought we fixed that long time ago?!?!
> > 
> > Nope, a simple `make oldconfig' breaks the symlink.
> 
> KCONFIG_OVERWRITECONFIG was added especially for you. :-)
> 

But nobody told me!

It works, thanks ;)
