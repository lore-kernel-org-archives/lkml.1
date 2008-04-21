Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYDVFFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYDVFFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 01:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYDVFEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 01:04:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:41008 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYDVFEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 01:04:53 -0400
Date: Mon, 21 Apr 2008 14:44:26 -0700
From: Greg KH <gregkh@suse.de>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.25-mm1 -- WARNING: at fs/sysfs/dir.c:427
	sysfs_add_one+0x33/0x9a()
Message-ID: <20080421214426.GA9847@suse.de>
References: <a44ae5cd0804181124s772fa61bp22035c2b758471b1@mail.gmail.com> <a44ae5cd0804211156n40e2a71cw25c3114db2f58d17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0804211156n40e2a71cw25c3114db2f58d17@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 02:56:52PM -0400, Miles Lane wrote:
> Is anyone interesting in following up on this?

Did you follow what the kernel told you to do to resolve this:

> >  [    5.097978] disabling CONFIG_USB_DEVICE_CLASS might fix this

Anyway, this was removed already from the -mm tree, so it will not show
up again, hopefully.

thanks,

greg k-h
