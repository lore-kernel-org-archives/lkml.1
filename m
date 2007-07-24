Return-Path: <linux-kernel-owner+w=401wt.eu-S1764656AbXGXIHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656AbXGXIHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXGXIHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:07:35 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33935 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbXGXIHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:07:32 -0400
Date: Tue, 24 Jul 2007 10:08:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: i386 section mismatch warnings
Message-ID: <20070724080847.GA13804@uranus.ravnborg.org>
References: <46A5536E.6010606@garzik.org> <20070724014512.GO21668@ftp.linux.org.uk> <46A5AEE0.1070202@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A5AEE0.1070202@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 09:48:48AM +0200, Gabriel C wrote:
> Al Viro wrote:
> > On Mon, Jul 23, 2007 at 09:18:38PM -0400, Jeff Garzik wrote:
> >> make allmodconfig on i386:
> >>
> >> WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to 
> > 
> > Ignore.  vmlinux.o ones are interesting; so are ones in modules.
> > vmlinux ones are either duplicates of vmlinux.o or false positives.
> 
> allyesconfig has a lot Section mismatch warnings , are these false positive too ?
> 
> 
> http://lkml.org/lkml/2007/7/22/312

The first group are to be solved.
The last group can be ignored.

I have saved your original mail but not yet looked into any of them.
I assume that a few hours work can bring down the list considerably but
I was sidetracked by a book (HP7) ;-)

	Sam
