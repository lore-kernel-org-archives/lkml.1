Return-Path: <linux-kernel-owner+w=401wt.eu-S1762053AbXHTV76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762053AbXHTV76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXHTV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:59:48 -0400
Received: from ns.suse.de ([195.135.220.2]:57093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbXHTV7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:59:48 -0400
Date: Mon, 20 Aug 2007 14:42:01 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions v2
Message-ID: <20070820214201.GA6516@suse.de>
References: <46C9BAF7.1050409@googlemail.com> <Pine.LNX.4.44L0.0708201649400.8219-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708201649400.8219-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 04:52:47PM -0400, Alan Stern wrote:
> On Mon, 20 Aug 2007, Michal Piotrowski wrote:
> 
> > Subject         : USB-related oops in sysfs with linux v2.6.23-rc3-50-g28e8351
> > References      : http://lkml.org/lkml/2007/8/15/144
> > Last known good : ?
> > Submitter       : Florin Iucha <florin@iucha.net>
> > Caused-By       : ?
> > Handled-By      : ?
> > Status          : problem is being debugged
> 
> A patch was submitted and confirmed to fix the problem:
> 
> 	http://marc.info/?l=linux-kernel&m=118729528713044&w=2
> 
> The patch hasn't been merged yet.  (And incidentally, it wasn't really
> an oops -- it was just a warning and stack dump.)

Yes, it's just a warning, and it's in my queue to go to Linus for
2.6.23.

thanks,

greg k-h
