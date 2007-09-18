Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbXIROcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbXIROcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbXIRObs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:31:48 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42800 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbXIRObq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:31:46 -0400
Subject: Re: [2/3] 2.6.23-rc6: known regressions v2
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       sct@redhat.com, adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       netdev@vger.kernel.org, Shish <shish@shishnet.org>,
       Karl Meyer <adhocrocker@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Daniel Drake <dsd@gentoo.org>,
       Oliver Neukum <oliver@neukum.org>,
       linux-usb-devel@lists.sourceforge.net, Florian Lohoff <flo@rfc822.org>,
       Toralf F?rster <toralf.foerster@gmx.de>
In-Reply-To: <20070918142443.GA13304@atrey.karlin.mff.cuni.cz>
References: <46EB3E94.7080704@googlemail.com> <46EB4371.307@googlemail.com>
	 <20070918142443.GA13304@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 09:31:41 -0500
Message-Id: <1190125901.6528.7.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 16:24 +0200, Jan Kara wrote:

> > Subject         : umount triggers a warning in jfs and takes almost a minute
> > References      : http://lkml.org/lkml/2007/9/4/73
> > Last known good : ?
> > Submitter       : Oliver Neukum <oliver@neukum.org>
> > Caused-By       : ?
> > Handled-By      : ?
> > Status          : unknown
>   I thought Shaggy asked Oliver about some details (and he did not
> answer so far) so I'd assume Shaggy is handling this.

I've put it on the back-burner since I haven't heard back from Oliver.
I still haven't found out whether or not it is a regression.  I'm not
too concerned about fixing it right away.  I don't think jfs on flash is
very important.

-- 
David Kleikamp
IBM Linux Technology Center

