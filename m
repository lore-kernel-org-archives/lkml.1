Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZDWCL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZDWCL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZDWCLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:11:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:55575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZDWCLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:11:19 -0400
Message-ID: <49EFCE29.7050903@kernel.org>
Date: Thu, 23 Apr 2009 11:10:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [GIT PATCH linux-2.6-block] block: cleanup patches, take#3
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <20090422101038.GA4593@kernel.dk>
In-Reply-To: <20090422101038.GA4593@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 02:10:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jens Axboe wrote:
>> linux-2.6-block#for-next(a95320f3ede3f028837a621715cd352e83ffe7c2)
>> + linux-2.6-ide#for-next(2ecf0a57c60dcb588f310d94412118e15c510532)
> 
> Looks nice, the only real quibble I have is the one that hch also brings
> up. Using a 'locked' argument is always ugly. Otherwise, overall the
> patchset is really nice and does good cleanups. Getting rid of ->data is
> great as well.
> 
> Once we get that settled, pulling into for-2.6.31 will be done.

Tree updated.  In addition to the @locked removal, Acked-by:'s are
added to 0012 and 0013 got a proper arm-omap prefix.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cleanup

Thanks.

-- 
tejun
