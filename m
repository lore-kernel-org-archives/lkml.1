Return-Path: <linux-kernel-owner+w=401wt.eu-S1763170AbYBNTGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763170AbYBNTGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbYBNTGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:06:37 -0500
Received: from hu-out-0506.google.com ([72.14.214.239]:44637 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbYBNTGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:06:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ldECMHRHmAROgWaekb2+6XGE6y/LngXM+rX6aPkr8Dsfre+RNUzMIG+w6xhejDFK9ugQb7A16VMmeMH18yI/mGbUGanOkadVE0CHhDQl8LFi/Wzi672WkivN+PBOP8d94GUvmp6iDIxT79r6IGd3KQpFa2s5VprICm7JziWJsMk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: quilt series
Date: Thu, 14 Feb 2008 20:20:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alasdair G Kergon <agk@redhat.com>,
       Jean Delvare <khali@linux-fr.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
References: <20080215014210.73c71078.sfr@canb.auug.org.au>
In-Reply-To: <20080215014210.73c71078.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802142020.40218.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Stephen Rothwell wrote:
> Hi all,
> 
> To make my life easier, can I ask that the series file for any quilt trees in the linux-next tree have a comment at the top to identify their base (either a SHA1 or some other ref in Linus' tree).  Like this:
> 
> # BASE <SHA1 or ref>

done:

	# BASE commit 96b5a46e2a72dc1829370c87053e0cd558d58bc0

Please add

	http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/

to linux-next.

Thanks,
Bart
