Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZFEPTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZFEPTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZFEPTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:19:08 -0400
Received: from windsormachine.com ([216.8.138.2]:34493 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZFEPTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:19:07 -0400
Date: Fri, 5 Jun 2009 11:19:06 -0400 (EDT)
From: Mike Dresser <mdresser_l@windsormachine.com>
To: Christoph Hellwig <hch@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alex Samad <alex@samad.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
In-Reply-To: <20090605093234.GA30705@infradead.org>
Message-ID: <alpine.DEB.1.10.0906051115580.16086@router.windsormachine.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A._pF.ZVbIKB@chimera> <20090530231018.GA29992@samad.com.au> <200906012221.38854.rjw@sisk.pl> <4A27DA01.8060105@windsormachine.com> <20090604143406.GA19536@infradead.org>
 <alpine.DEB.1.10.0906041038500.15712@router.windsormachine.com> <20090605093234.GA30705@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Christoph Hellwig wrote:

> I haven't actually measured it, but it shouldn't be that bad.  Mostly

I've enabled that as of yesterday and I'll let it go through it's normal 
operations.. It did survive the other night without CONFIG_XFS_DEBUG 
on(and on 2.6.30-rc8), but that sometimes happened anyways.

If it makes it through this weekend without crashing then that bodes well 
for something being fixed in the recent rc's.

Doesn't seem to be any slower though, the backups completed around the 
same time as they always do.

Mike



