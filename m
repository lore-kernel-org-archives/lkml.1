Return-Path: <linux-kernel-owner+w=401wt.eu-S1031241AbXHMRYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031241AbXHMRYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032479AbXHMRTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:19:47 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38036 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032332AbXHMRTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:19:44 -0400
Subject: Re: [PATCH] [188/2many] MAINTAINERS - EXT4 FILE SYSTEM
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Joe Perches <joe@perches.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
       torvalds@linux-foundation.org, sct@redhat.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       akpm@linux-foundation.org, Eric Sandeen <esandeen@redhat.com>
In-Reply-To: <1187024133.10249.113.camel@localhost>
References: <46bff9cc.cxIrFM29roaPmcfV%joe@perches.com>
	 <20070813090128.GJ6689@schatzie.adilger.int>
	 <20070813151917.GA28130@thunk.org> <1187021641.10249.90.camel@localhost>
	 <46C08941.20609@redhat.com>  <1187024133.10249.113.camel@localhost>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 13 Aug 2007 10:19:39 -0700
Message-Id: <1187025579.3876.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 09:55 -0700, Joe Perches wrote:
> On Mon, 2007-08-13 at 11:39 -0500, Eric Sandeen wrote:
> > (And to be fair about it in terms of actual work done so far, please
> > put
> > the other names ahead of mine!)  :)
> 
> EXT4 FILE SYSTEM
> P:	Ted Ts'o
> M:	tytso@mit.edu
> P:	Mingming Cao
> M:	cmm@us.ibm.com
> P:	Andreas Dilger
> M:	adilger@clusterfs.com
> P:	Eric Sandeen
> M:	sandeen@redhat.com
> L:	linux-ext4@vger.kernel.org
> S:	Maintained
> F:	fs/ext4/
> F:	include/linux/ext4*
> 

Probably should add Shaggy (Dave Kleikamp <shaggy@austin.ibm.com>) here
too. He helped push ext4 fs into mainline and actively performing ext4
patch queue maintainence. 


Mingming

