Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbYLWRUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbYLWRUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLWRU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:20:26 -0500
Received: from kroah.org ([198.145.64.141]:49228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751143AbYLWRU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:20:26 -0500
Date: Tue, 23 Dec 2008 09:16:07 -0800
From: Greg KH <greg@kroah.com>
To: Diego Raschi <draschi@ibs.sm>
Cc: "'Al Viro'" <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] R: BUG smbd crash
Message-ID: <20081223171607.GA4043@kroah.com>
References: <20081222211316.GM28946@ZenIV.linux.org.uk> <00a801c9651e$8fb29700$1b02a8c0@client018>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00a801c9651e$8fb29700$1b02a8c0@client018>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 05:50:28PM +0100, Diego Raschi wrote:
> I try to compile the kernel source 2.6.27.10 with make dep;make clean;make
> menuconfig;make bzImage;make modules;make modules_install
> But int the dir /lib/modules/2.6.27.10 is only 54Mb of driver. All of make
> don't go on error.
> 
> After I try to compile the kernel source 2.6.27.8 and all make generate
> 676Mb on dir /lib/modules/2.6.27.8.
> What I wrong?

If you are relying on a Fedora kenrel, I suggest you contact the Fedora
developers to get them to add the 2.6.27.10 release into their
repository to make it easier for you do resolve this issue.

good luck,

greg k-h
