Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYAQVzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYAQVzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYAQVza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:55:30 -0500
Received: from 1wt.eu ([62.212.114.60]:1385 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbYAQVz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:55:29 -0500
Date: Thu, 17 Jan 2008 22:32:25 +0100
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.16.58
Message-ID: <20080117213225.GF8953@1wt.eu>
References: <20080115221832.GA4449@does.not.exist> <Pine.LNX.4.64.0801161703190.15647@twin.jikos.cz> <20080117203416.GK23696@does.not.exist> <20080117211205.GE8953@1wt.eu> <20080117214755.GB28233@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117214755.GB28233@does.not.exist>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 11:47:55PM +0200, Adrian Bunk wrote:
> On Thu, Jan 17, 2008 at 10:12:05PM +0100, Willy Tarreau wrote:
> > Hi Adrian,
> > 
> > On Thu, Jan 17, 2008 at 10:34:16PM +0200, Adrian Bunk wrote:
> > > do you insist on hearing the truth ("Sorry, I forgot to push."), or can 
> > > I tell you "I just wanted to see whether anyone notices." instead?  ;-)
> > 
> > :-)
> > 
> > I think we should intentionally do this test once in a while. Two days
> > ago I was informed that 2.6.20.21 (the latest 2.6.20 I pushed 3 months
> > ago) was not clonable nor pullable due to a problem with the HEAD
> > pointing to latest tag instead of latest commit. Since the error was
> > also present in my local tree, I'm certain that it remained there
> > unnoticed for 3 months !
> 
> According to git [1] Ralf merged 2.6.20.21 on 2007-10-18 into the 2.6.20 
> branch of his mips tree, so it must have been somehow possible...

Maybe he did this locally (Linus showed me that local FS cloning disables
a lot of tests). Or maybe it could work for some pulls :-/ Definitely a
weird issue anyway!

Cheers,
Willy

