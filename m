Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZFEHag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZFEHag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZFEHaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:30:14 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:33328 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZFEHaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:30:12 -0400
Date: Fri, 5 Jun 2009 09:24:12 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090605072412.GF6411@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain> <20090604170820.GA9823@prithivi.gnumonks.org> <200906041218.44683.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041218.44683.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:18:42PM -0500, Michael S. Zick wrote:
> > In any case, if somebody can ship me a system that exposes one of those
> > lock-ups, together with a pre-installed test case that exposes the problem
> > within let's say less than one day, plus the full kernel sources used in
> > that particular system:  I'm happy to spend time to investigate the issue,
> > try to run the same test case on a VIA board, etc.
> 
> I am about at my wits end with this Everex product -
> 
> Give me a couple more weeks at the problem and if I haven't solved it;
> I'll give you this machine if you promise to update LKML with any fix.

Well, I cannnot promise that I will actually find the problem and find a fix.
But I can promise to look into the issue and potentially ask other people
at VIA/Centaur to help with investigating it.

And as soon as the problem can be reproduced, or we have a fix, or I give up,
you would get the system back, obviously.

I'll try to figure out how we can do the shipping while billing it to VIA's
account.

In any case, let's wait until I hear from VIA if they can provide one of those
machines to me.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
