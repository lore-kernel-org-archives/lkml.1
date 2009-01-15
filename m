Return-Path: <linux-kernel-owner+w=401wt.eu-S935004AbZAOXwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935004AbZAOXwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZAOXwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:52:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486AbZAOXwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:52:15 -0500
Date: Thu, 15 Jan 2009 15:51:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
       mhalcrow@us.ibm.com
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a
 question
Message-Id: <20090115155143.e4509e7e.akpm@linux-foundation.org>
In-Reply-To: <496FC91C.10806@linux.vnet.ibm.com>
References: <7471.1231827621@jrobl>
	<20090115150332.f72ad0f8.akpm@linux-foundation.org>
	<496FC91C.10806@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 17:39:08 -0600
Tyler Hicks <tyhicks@linux.vnet.ibm.com> wrote:

> > I am puzzled by the current ecryptfs maintenance situation.
> > 
> 
> http://article.gmane.org/gmane.linux.kernel/768122
> 
> The torch has been passed to me.  :)

yup, thanks.

> > I queued this for 2.6.30.  It could be bumped up for 2.6.29 (and even
> > backported to 2.6.28 and earlier) with suitable acks from the
> > maintainer(?)
> > 
> 
> The changes to ecryptfs_rmdir() are valid, but not the rest of the patch.
> 

OK, I'll drop my copy.  Please send something back at me sometime, with
indications about which kernel version(s) it should be merged into.

We should chase J.R.  for a Signed-off-by:, which was omitted from the
original patch.

