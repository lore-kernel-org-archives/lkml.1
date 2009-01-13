Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbZAMWMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbZAMWMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZAMWMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:12:31 -0500
Received: from kroah.org ([198.145.64.141]:39351 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754806AbZAMWMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:12:30 -0500
Date: Tue, 13 Jan 2009 14:10:15 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] STAGING patches for 2.6-git
Message-ID: <20090113221015.GA24217@kroah.com>
References: <20090106221129.GB32689@kroah.com> <alpine.LFD.2.00.0901131012530.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901131012530.6528@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 10:13:35AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 6 Jan 2009, Greg KH wrote:
> >
> > Here are some staging patches against your 2.6 git tree, all safe and
> > self-contained in the drivers/staging/ portion of the tree.
> 
> Ok, I can confirm that the rt2860 driver works and makes newer eeepc's 
> useful. But I haven't looked at the sources, since I'm a wuss.

Yeah!

Thanks for letting me know, I was worried that the netdev->private
cleanup I did on that driver was incorrect as I didn't have anything
at-hand to test it on.

greg k-h
