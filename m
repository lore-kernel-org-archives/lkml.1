Return-Path: <linux-kernel-owner+w=401wt.eu-S937839AbXGMWyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937839AbXGMWyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXGMWyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:54:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbXGMWyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:54:11 -0400
Date: Fri, 13 Jul 2007 15:54:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, raziebe@gmail.com, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm PATCH 0/2] 74% decrease in dispatched writes, stripe-queue
 take3
Message-Id: <20070713155400.24689606.akpm@linux-foundation.org>
In-Reply-To: <20070713223257.25202.74399.stgit@dwillia2-linux.ch.intel.com>
References: <20070713223257.25202.74399.stgit@dwillia2-linux.ch.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 15:35:42 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The following patches replace the stripe-queue patches currently in -mm.

I have a little practical problem here: am presently unable to compile
anything much due to all the git rejects coming out of git-md-accel.patch.

It'd be appreciated if you could keep on top of that, please.  It's a common
problem at this time of the kernel cycle.  The quilt trees are much worse - Greg's
stuff is an unholy mess.  Ho hum.
