Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYHSW7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYHSW7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbYHSW6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:58:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbYHSW6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:58:20 -0400
Date: Wed, 20 Aug 2008 00:56:25 +0200
From: Karel Zak <kzak@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, miklos@szeredi.hu
Subject: Re: [PATCH v2] documentation: split and build smount.c
Message-ID: <20080819225625.GG2846@nb.net.home>
References: <20080817214442.ca4345ce.randy.dunlap@oracle.com> <20080818050431.GA20692@infradead.org> <20080818181409.f2861821.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818181409.f2861821.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 06:14:09PM -0700, Randy Dunlap wrote:
> On Mon, 18 Aug 2008 01:04:31 -0400 Christoph Hellwig wrote:
> 
> > Just remove it, and modern /bin/mount handles shared subtrees just fine
> 
> Miklos... ?
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> mount(8) handles shared subtrees just fine, so remove the smount
> program from Documentation/filesystems/sharedsubtree.txt.
[...]
> +	Note: mount(8) command now supports the --make-shared flag,

 Right, ACK ;-)

>  	#mount --bind /mnt /tmp

 BTW, people usually use a space between prompt and command, so:

   # mount --bind /mnt /tmp


    Karel


-- 
 Karel Zak  <kzak@redhat.com>
