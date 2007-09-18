Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbXIROY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbXIROY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbXIROYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:24:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53926 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbXIROYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:24:44 -0400
Date: Tue, 18 Sep 2007 16:24:43 +0200
From: Jan Kara <jack@suse.cz>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       sct@redhat.com, adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       netdev@vger.kernel.org, Shish <shish@shishnet.org>,
       Karl Meyer <adhocrocker@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Daniel Drake <dsd@gentoo.org>,
       Oliver Neukum <oliver@neukum.org>,
       linux-usb-devel@lists.sourceforge.net, Florian Lohoff <flo@rfc822.org>,
       Toralf F?rster <toralf.foerster@gmx.de>
Subject: Re: [2/3] 2.6.23-rc6: known regressions v2
Message-ID: <20070918142443.GA13304@atrey.karlin.mff.cuni.cz>
References: <46EB3E94.7080704@googlemail.com> <46EB4371.307@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EB4371.307@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> FS
> 
> Subject         : hanging ext3 dbench tests
> References      : http://lkml.org/lkml/2007/9/11/176
> Last known good : ?
> Submitter       : Andy Whitcroft <apw@shadowen.org>
> Caused-By       : ?
> Handled-By      : ?
> Status          : under test -- unreproducible at present
  Yep... Hard to do anything until Andy is able to reproduce it at least
once more to gather needed info.

> Subject         : umount triggers a warning in jfs and takes almost a minute
> References      : http://lkml.org/lkml/2007/9/4/73
> Last known good : ?
> Submitter       : Oliver Neukum <oliver@neukum.org>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown
  I thought Shaggy asked Oliver about some details (and he did not
answer so far) so I'd assume Shaggy is handling this.

										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
