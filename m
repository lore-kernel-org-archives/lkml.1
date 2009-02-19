Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZBSLs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZBSLs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZBSLsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:48:18 -0500
Received: from ozlabs.org ([203.10.76.45]:40281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZBSLsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:48:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [s390] next Feb 18: defconfig build break
Date: Thu, 19 Feb 2009 22:18:10 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Sachin P. Sant" <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <20090218191640.0b023029.sfr@canb.auug.org.au> <200902191045.25878.rusty@rustcorp.com.au> <20090219095150.GA5808@flint.arm.linux.org.uk>
In-Reply-To: <20090219095150.GA5808@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192218.11781.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 20:21:50 Russell King wrote:
> On Thu, Feb 19, 2009 at 10:45:25AM +1030, Rusty Russell wrote:
> > Subject: arm: allow usage of string functions in linux/string.h
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> I guess this should go in with the change which caused the breakage.

Well, feel free to queue it yourself too, but now you've acked it I've put it
in my queue ahead of the strstarts patch.

Thanks,
Rusty.
