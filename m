Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbYG2Uii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbYG2Uii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYG2Uib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:38:31 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:35652 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbYG2Uia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:38:30 -0400
Date: Tue, 29 Jul 2008 16:36:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
In-Reply-To: <20080729091707.d82b389a.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0807291635550.13165@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain> <20080726094718.b617c1e7.randy.dunlap@oracle.com> <alpine.LFD.1.10.0807261750340.3493@localhost.localdomain> <1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
 <alpine.LFD.1.10.0807280531210.3402@localhost.localdomain> <20080728103731.7bafd577.randy.dunlap@oracle.com> <alpine.LFD.1.10.0807281437070.10586@localhost.localdomain> <1217282540.22927.13.camel@zem.phub.net.cable.rogers.com> <20080728151441.03410ecd.randy.dunlap@oracle.com>
 <alpine.LFD.1.10.0807290634510.7057@localhost.localdomain> <20080729091707.d82b389a.randy.dunlap@oracle.com>
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

On Tue, 29 Jul 2008, Randy Dunlap wrote:

> On Tue, 29 Jul 2008 06:36:09 -0400 (EDT) Robert P. J. Day wrote:

> > so, just to be clear, the consensus is to just leave it alone as
> > it's more trouble than it's worth to do anything about?
>
> Probably.
>
> I don't see the "if PARTITION_ADVANCED" block as being compatible
> with the need to have default partition types per $ARCH. Do you see
> some way around that problem?

not presently.  and if i was going to invest more effort, i'd probably
be more tempted to try to reorg the train wreck that is the "Kernel
hacking" submenu, anyway.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
