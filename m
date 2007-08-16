Return-Path: <linux-kernel-owner+w=401wt.eu-S932677AbXHPHvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbXHPHvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbXHPHvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:51:11 -0400
Received: from host2.marvell.com ([65.219.4.2]:47150 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755888AbXHPHvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:51:09 -0400
X-Greylist: delayed 1769 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 03:51:09 EDT
Message-ID: <46C3FB01.9090203@gmail.com>
Date: Thu, 16 Aug 2007 15:21:37 +0800
From: eric miao <eric.y.miao@gmail.com>
Reply-To: eric.y.miao@gmail.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: ye janboe <janboe.ye@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how can I get an account on master.kernel.org machine
References: <af3ea28a0708151958h4af993e6o1db3b9adddc14294@mail.gmail.com> <20070815201421.ffbd84f3.randy.dunlap@oracle.com>
In-Reply-To: <20070815201421.ffbd84f3.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

And if you purpose is only to download that tree, my suggestion is that
some of the git trees are not public like linux-arm so the owner can do
whatever he likes in the tree, and don't ever try to have access to it.

for linux-arm, it will be constantly pulled by Linus, unless you really
want the _most_ up-to-date patches, which you might find them at

  http://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/

that folder will be constantly refreshed by the maintainer.

- eric

Randy Dunlap wrote:
> On Thu, 16 Aug 2007 10:58:41 +0800 ye janboe wrote:
> 
>> I want to down linux-arm git repos, but I do not have an account on
>> master machine.
> 
> see http://www.kernel.org/faq/#account
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

