Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbXINRV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbXINRV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 13:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXINRVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 13:21:48 -0400
Received: from mail.fieldses.org ([66.93.2.214]:33722 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbXINRVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 13:21:46 -0400
Date: Fri, 14 Sep 2007 13:21:25 -0400
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Clayton <andrew@digital-domain.net>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       sct@redhat.com, adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, dth <dth@dth.net>,
       Neil Brown <neilb@suse.de>
Subject: Re: [2/4] 2.6.23-rc6: known regressions
Message-ID: <20070914172124.GA2419@fieldses.org>
References: <46E8187E.9000006@googlemail.com> <46E81ACE.6030305@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E81ACE.6030305@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 06:58:54PM +0200, Michal Piotrowski wrote:
> Subject         : [NFSv4] 2.6.23-rc4 oops in nfs4_cb_recall
> References      : http://lkml.org/lkml/2007/9/4/53
>                   http://bugzilla.kernel.org/show_bug.cgi?id=9003
> Last known good : ?
> Submitter       : Daniel J Blueman <daniel.blueman@gmail.com>
> Caused-By       : ?
> Handled-By      : ?
> Workaround      : http://bugzilla.kernel.org/attachment.cgi?id=12797
> Status          : unknown

I have patches which fix this, which we're testing.  (See bugzilla.)
It's a long-standing bug, not a regression.

> Subject         : [NFSD OOPS] 2.6.23-rc1-git10
> References      : http://lkml.org/lkml/2007/8/2/462
> Last known good : ?
> Submitter       : Andrew Clayton <andrew@digital-domain.net>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

Neil's working on this.  Also not a regression.

--b.
