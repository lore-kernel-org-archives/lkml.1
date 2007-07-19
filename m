Return-Path: <linux-kernel-owner+w=401wt.eu-S965386AbXGSTL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965386AbXGSTL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765618AbXGSTLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:11:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:53778 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbXGSTK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:10:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CwExYaol6ZUC9W4G9VFR6uSZvM7iFbbpEe1tgafT8tFguBNFGkTEiTFg4njntoz5Fon7keBDLRv6/2cpJSHN6Y68va0pcJ5STM4SuZJKBNnzZILW6w13KfPjhgxgxq3hPnwqViNg5D61ZwWEcufR04JTgyhh/pV+YADQ3N+zfiE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.22-git: known regressions with patches
Date: Thu, 19 Jul 2007 21:21:08 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Giacomo Catenazzi <cate@cateee.net>, Jens Axboe <jens.axboe@oracle.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jens Axboe <axboe@suse.de>,
       "Peter M. Jones" <pjones@redhat.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>,
       Meelis Roos <mroos@linux.ee>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
References: <469F92B8.5090809@googlemail.com>
In-Reply-To: <469F92B8.5090809@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192121.08869.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 19 July 2007, Michal Piotrowski wrote:

> Unclassified
> 
> Subject         : disk error loop (panic?) ide_do_rw_disk-bad
> References      : http://lkml.org/lkml/2007/7/17/467
> Last known good : ?
> Submitter       : Giacomo Catenazzi <cate@cateee.net>
> Caused-By       : ?
> Handled-By      : Jens Axboe <jens.axboe@oracle.com>
>                   Linus Torvalds <torvalds@linux-foundation.org>
>                   Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Patch           : http://lkml.org/lkml/2007/7/19/26
> Status          : patch available

Additional patch is an improvement but the regression itself has already
been fixed in the mainline (by reverting problematic changes).

Thanks,
Bart
