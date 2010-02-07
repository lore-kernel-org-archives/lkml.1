Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab0BGSkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 13:40:04 -0500
Received: from 8bytes.org ([88.198.83.132]:49164 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab0BGSj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 13:39:57 -0500
Date: Sun, 7 Feb 2010 19:39:56 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joel Becker <Joel.Becker@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
Message-ID: <20100207183956.GB26388@8bytes.org>
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain> <20100207102016.GH3416@mail.oracle.com> <alpine.LFD.2.00.1002071029040.3829@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002071029040.3829@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 10:32:02AM -0800, Linus Torvalds wrote:
> Another option might be to stop generating the .bz2 files, of course. 
> Anybody who cares more about network bandwidth than CPU use (ie people who 
> would seem to prefer bz2) would be better off using git instead, which 
> packs things _way_ better, by virtue of being much more incremental.

The .bz2 files are downloaded by the ketchup script. I use it sometimes
to get a specific kernel tree version on a machine without having to
look up the urls to download them manually. So there are users for the
.bz2 files too ;-)

	Joerg

