Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZALIH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZALIH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZALIHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:07:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39933 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZALIHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:07:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.28-git-4 - powerpc - kernel expection 'c01 at .kernel_thread'
Date: Mon, 12 Jan 2009 09:07:19 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-mm@kvack.org,
       sfr@canb.auug.org.au, benh@kernel.crashing.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, mel@csn.ul.ie
References: <20090102125752.GA5743@linux.vnet.ibm.com> <200901110108.20848.rjw@sisk.pl> <20090112072132.GA8409@linux.vnet.ibm.com>
In-Reply-To: <20090112072132.GA8409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901120907.20418.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009, Kamalesh Babulal wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> [2009-01-11 01:08:19]:
> 
> > On Friday 02 January 2009, Kamalesh Babulal wrote:
> > > Hi,
> > > 
> > > 	2.6.28-git4 kernel drops to xmon with kernel expection. Similar kernel
> > > expection was seen next-20081230 and next-20081231 and was reported 
> > > earlier at http://lkml.org/lkml/2008/12/31/157
> > 
> > Is this a regression from 2.6.27?
> > 
> > Rafael
> >
> 
> This is not a regression from 2.6.27, this expection was first seen 
> next-20081230 patches and then was introduced into 2.6.28-git4 and is 
> reproducible with 2.6.28-rc1 kernel.

Presumably you meant 2.6.29-rc1 ?  In which case it would be a regression from
2.6.28 .  Please confirm.

Thanks,
Rafael
