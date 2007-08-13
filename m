Return-Path: <linux-kernel-owner+w=401wt.eu-S948331AbXHMQ0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948331AbXHMQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031032AbXHMPTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:19:25 -0400
Received: from THUNK.ORG ([69.25.196.29]:48753 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S947206AbXHMPTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:19:23 -0400
Date: Mon, 13 Aug 2007 11:19:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: joe@perches.com, torvalds@linux-foundation.org, sct@redhat.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       akpm@linux-foundation.org, Eric Sandeen <esandeen@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] [188/2many] MAINTAINERS - EXT4 FILE SYSTEM
Message-ID: <20070813151917.GA28130@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, joe@perches.com,
	torvalds@linux-foundation.org, sct@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, Eric Sandeen <esandeen@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>
References: <46bff9cc.cxIrFM29roaPmcfV%joe@perches.com> <20070813090128.GJ6689@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813090128.GJ6689@schatzie.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 03:01:28AM -0600, Andreas Dilger wrote:
> >  EXT4 FILE SYSTEM
> > -P:	Stephen Tweedie, Andrew Morton
> > -M:	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
> > +P:	Stephen Tweedie
> > +M:	sct@redhat.com
> > +P:	Andrew Morton
> > +M:	akpm@linux-foundation.org
> > +P:	Andreas Dilger
> > +M:	adilger@clusterfs.com
> >  L:	linux-ext4@vger.kernel.org
> >  S:	Maintained
> > +F:	fs/ext4/
> > +F:	include/linux/ext4*
> 
> To be honest, Stephen and Andrew haven't been directly involved in
> the ext4 development.  It probably makes more sense to have e.g.
> Eric Sandeen, Ted Ts'o, and MingMing Cao in their place.

Yep, agreed.

					- Ted
