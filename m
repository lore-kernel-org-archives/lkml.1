Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbYCUSIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbYCUSIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYCUSIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:08:45 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40254 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbYCUSIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:08:44 -0400
Date: Fri, 21 Mar 2008 14:08:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's with the "pre-releases" directory?
In-Reply-To: <20080321175651.GC1434@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.00.0803211407510.12549@localhost.localdomain>
References: <alpine.LFD.1.00.0803211312500.30701@localhost.localdomain> <20080321173415.GB1434@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0803211336350.7227@localhost.localdomain> <20080321175651.GC1434@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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

On Fri, 21 Mar 2008, Adrian Bunk wrote:

> On Fri, Mar 21, 2008 at 01:41:36PM -0400, Robert P. J. Day wrote:

> > p.s.  and while i'm whining, would it be possible to clear the
> > obsolete "LATEST-IS" files out of:
> >
> >   ftp://ftp.kernel.org/pub/linux/kernel/v2.6/testing
> >
> > i have a script that grabs the latest rc tarball out of that
> > directory, and it got confused by seeing more than one LATEST-IS file.
> > not hard to work around but, still ...
>
> For this you have to whine to the guy who places them there:
>
> -rw-rw-r--  1 torvalds kernel         0 Mar  5 04:44 LATEST-IS-2.6.25-rc4
> -rw-rw-r--  1 torvalds kernel         0 Mar 10 05:30 LATEST-IS-2.6.25-rc5
> -rw-rw-r--  1 torvalds kernel         0 Mar 16 23:50 LATEST-IS-2.6.25-rc6

darned newbies.  :-P

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
