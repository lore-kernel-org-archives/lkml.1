Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZGJWWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZGJWWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 18:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbZGJWWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 18:22:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57615 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719AbZGJWWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 18:22:15 -0400
Message-ID: <4A57BF06.1070601@garzik.org>
Date: Fri, 10 Jul 2009 18:21:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       open-osd mailing-list <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [GIT PULL resend] exofs/osd tree for 2.6.31-rc2
References: <4A54666C.5010407@panasas.com>
In-Reply-To: <4A54666C.5010407@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> Linus
> 
> Please pull the following exofs/OSD changes from the git repository at:
> 
>   git://git.open-osd.org/linux-open-osd.git for-linus
> 
> These are a few fixes/cleanups and mainly a new block-device driver
> from Jeff Garzik, that can export an OSD object to block-based users
> like filesystems.
> 
> Since they are all small bug fixes, the copyrights adjustment should be looked
> at as a bug in the file ownership. (the original removal request came from IBM.)
> And one new driver. It might be said that we do not violate -rc rules with this.
> 
> Boaz Harrosh (5):
>       exofs: Fix bio leak in error handling path (sync read)
>       exofs: Remove IBM copyrights
>       exofs: Avoid using file_fsync()
>       MAINTAINERS: Add osd maintained files (F:)
>       osdblk: Adjust queue limits to lower device's limits
> 
> Jeff Garzik (1):
>       osdblk: a Linux block device for OSD objects

Ping...   is there a problem with this pull?

Maybe Linus is expecting exofs stuff through James?

	Jeff




