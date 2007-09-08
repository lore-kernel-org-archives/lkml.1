Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXIHNDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXIHNDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 09:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXIHNDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 09:03:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbXIHNDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 09:03:05 -0400
Date: Sat, 8 Sep 2007 05:28:52 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Clayton <andrew@digital-domain.net>, Ian Kent <raven@themaw.net>,
       autofs@linux.kernel.org, Daniel J Blueman <daniel.blueman@gmail.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [2/4] 2.6.23-rc5: known regressions v2
Message-ID: <20070908122852.GA30315@suse.de>
References: <46E27DEF.7060109@googlemail.com> <46E28351.8050900@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E28351.8050900@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 01:11:13PM +0200, Michal Piotrowski wrote:
> USB
> 
> Subject         : 2.6.23-rc1: USB hard disk broken
> References      : http://lkml.org/lkml/2007/7/25/62
> Last known good : ?
> Submitter       : Tino Keitel <tino.keitel@gmx.de>
> Caused-By       : ?
> Handled-By      : Oliver Neukum <oliver@neukum.org>
> Status          : unknown
> 
> Subject         : USB hard disk broken in 2.6.23-rc3 (autosuspend related)
> References      : http://bugzilla.kernel.org/show_bug.cgi?id=8892
> Last known good : ?
> Submitter       : Roman Jarosz <kedgedev@centrum.cz>
> Caused-By       : ?
> Handled-By      : Alan Stern <stern@rowland.harvard.edu>
> Workaround      : echo -1 >/sys/bus/usb/devices/1-4/power/autosuspend
> Status          : possible hardware problem

Oliver and Alan, is there any info about these?  Anything that I can
help out with?

thanks,

greg k-h
