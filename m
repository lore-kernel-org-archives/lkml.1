Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYKLBKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYKLBKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYKLBKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:10:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:55579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbYKLBKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:10:01 -0500
Date: Tue, 11 Nov 2008 17:08:58 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: patch hfsplus-check-read_mapping_page-return-value.patch added
	to 2.6.27-stable tree
Message-ID: <20081112010858.GB14073@suse.de>
References: <20081111213503.5262649038@coco.kroah.org> <200811120117.34978.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811120117.34978.s.L-H@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 01:17:29AM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Dienstag, 11. November 2008, gregkh@suse.de wrote:
> > 
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: hfsplus: check read_mapping_page() return value (CVE-2008-4934)
> > 
> > to the 2.6.27-stable tree.  Its filename is
> > 
> >     hfsplus-check-read_mapping_page-return-value.patch
> > 
> > A git repo of this tree can be found at 
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > 
> > From 649f1ee6c705aab644035a7998d7b574193a598a Mon Sep 17 00:00:00 2001
> > From: Eric Sesterhenn <snakebyte@gmx.de>
> > Date: Wed, 15 Oct 2008 22:04:10 -0700
> > Subject: hfsplus: check read_mapping_page() return value (CVE-2008-4934)
> > 
> > From: Eric Sesterhenn <snakebyte@gmx.de>
> > 
> > commit 649f1ee6c705aab644035a7998d7b574193a598a upstream.
> 
> This exact patch is already present in 2.6.27.5 and subsequently fails to 
> apply.

Yeah, I messed up, sorry about that.  Now dropped.

greg k-h
