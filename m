Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbZIHW3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbZIHW3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZIHW3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:29:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbZIHW3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:29:09 -0400
Date: Tue, 8 Sep 2009 18:28:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: [RFC] IO scheduler based IO controller V9
Message-ID: <20090908222814.GA3558@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 05:30:49PM -0400, Vivek Goyal wrote:
> 
> Hi All,
> 
> Here is the V9 of the IO controller patches generated on top of 2.6.31-rc7.
> 
> For ease of patching, a consolidated patch is available here.
> 
> http://people.redhat.com/~vgoyal/io-controller/io-scheduler-based-io-controller-v9.patch
> 

Found few issues during testing. Sending 3 more patches for this series.
After some more testing, will merge these patches in higher level patches
and post V10.

Thanks
Vivek
