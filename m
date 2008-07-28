Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbYG1SP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbYG1SP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbYG1SPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:15:48 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56226 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbYG1SPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:15:48 -0400
Date: Mon, 28 Jul 2008 14:14:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
In-Reply-To: <20080728103731.7bafd577.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0807281413460.8104@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain> <20080726094718.b617c1e7.randy.dunlap@oracle.com> <alpine.LFD.1.10.0807261750340.3493@localhost.localdomain> <1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
 <alpine.LFD.1.10.0807280531210.3402@localhost.localdomain> <20080728103731.7bafd577.randy.dunlap@oracle.com>
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

On Mon, 28 Jul 2008, Randy Dunlap wrote:

>
> >   yes, it's nitpicking but, as it's laid out right now, it's
> > unnecessarily confusing and inconsistent.  but i don't know if there's
> > a trivial fix for it.
>
> Yes, I'd call MSDOS partitions basic, not Advanced, and then put all others
> under an Advanced menu that can be toggled on/off easily with menuconfig.
>
> Not quite trivial, but not messy either.
>
> Patch below.  Comments?

i'll check shortly and get back to you.  thanks.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
