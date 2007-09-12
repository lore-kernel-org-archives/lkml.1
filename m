Return-Path: <linux-kernel-owner+w=401wt.eu-S971103AbXILRiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971103AbXILRiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967503AbXILRhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:37:55 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1789 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967230AbXILRhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:37:53 -0400
Date: Wed, 12 Sep 2007 18:36:33 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Clayton <andrew@digital-domain.net>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net, sct@redhat.com,
       adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, dth <dth@dth.net>
Subject: Re: [2/4] 2.6.23-rc6: known regressions
Message-ID: <20070912173633.GG25604@shadowen.org>
References: <46E8187E.9000006@googlemail.com> <46E81ACE.6030305@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E81ACE.6030305@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 06:58:54PM +0200, Michal Piotrowski wrote:

> FS
> 
> Subject         : hanging ext3 dbench tests
> References      : http://lkml.org/lkml/2007/9/11/176
> Last known good : ?
> Submitter       : Andy Whitcroft <apw@shadowen.org>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

A number of attempts to reproduce this on these machines has yet to
re-trigger it.  I guess the Status is therefore "under test --
unreproducible at present"

-apw
