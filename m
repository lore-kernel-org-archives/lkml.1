Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXFFVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXFFVgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964975AbXFFVgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:36:22 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58499 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964934AbXFFVgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:36:20 -0400
Date: Wed, 6 Jun 2007 14:35:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: gregkh@suse.de
Cc: sandeen@sandeen.net, akpm@linux-foundation.org, htejun@gmail.com,
       linux-kernel@vger.kernel.org, maneesh@in.ibm.com, sandeen@redhat.com,
       stable@kernel.org
Subject: Re: [stable] patch
	sysfs-store-sysfs-inode-nrs-in-s_ino-to-avoid-readdir-oopses.patch
	queued to -stable tree
Message-ID: <20070606213543.GS3723@sequoia.sous-sol.org>
References: <46525648.8050807@sandeen.net> <20070606194950.D357EE83785@imap.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606194950.D357EE83785@imap.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* gregkh@suse.de (gregkh@suse.de) wrote:
> From: Eric Sandeen <sandeen@sandeen.net>
> Subject: sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses
> 
> Backport of
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/broken-out/gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
> 

I didn't put this into -stable queue because the ida version is not
upstream yet, so I don't think it's appropriate to backport it at this
point in time.

thanks,
-chris
