Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbXJ3NSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbXJ3NSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXJ3NSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:18:41 -0400
Received: from styx.suse.cz ([82.119.242.94]:36803 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752887AbXJ3NSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:18:40 -0400
Date: Tue, 30 Oct 2007 14:18:38 +0100
From: Jan Kara <jack@suse.cz>
To: Andy Whitcroft <andyw@uk.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-git18: ext2_check_page: bad entry in directory
Message-ID: <20071030131838.GE9702@duck.suse.cz>
References: <20071024131540.GV32058@shadowen.org> <20071024135900.GC2652@duck.suse.cz> <20071024143308.GA23139@shadowen.org> <20071024150302.GD2652@duck.suse.cz> <20071024170729.GC23139@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024170729.GC23139@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-10-07 18:07:29, Andy Whitcroft wrote:
> On Wed, Oct 24, 2007 at 05:03:03PM +0200, Jan Kara wrote:
> 
> > e2image -r /dev/sda1 - | gzip -dc root-image.gz
> 
> This thing is 27MB, I'll try and find some space to hold it and
> let you know where it is offlist.
  Just for info, 2.6.23+my ext2 patch works correctly on your image.
So it must be some bad interaction with other patches or merge problem or
something like that. Going to investigate more...

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
