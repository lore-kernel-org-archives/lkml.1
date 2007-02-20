Return-Path: <linux-kernel-owner+w=401wt.eu-S964776AbXBTHBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776AbXBTHBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964792AbXBTHBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:01:12 -0500
Received: from mail.suse.de ([195.135.220.2]:57762 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964776AbXBTHBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:01:11 -0500
Date: Mon, 19 Feb 2007 22:59:46 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.18.7
Message-ID: <20070220065946.GA11688@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.18.7 kernel.
It contains one NFS fix that if you run a NFS server, you might want to
apply.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.18.6 and 2.6.18.7, as it is small enough to do so.

The updated 2.6.18.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.18.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h
--------

 Makefile          |    2 +-
 fs/nfsd/nfs2acl.c |   17 ++++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

Summary of changes from v2.6.18.6 to v2.6.18.7
==============================================

Greg Banks (1):
      Fix a free-wrong-pointer bug in nfs/acl server (CVE-2007-0772)

Greg Kroah-Hartman (1):
      Linux 2.6.18.7

