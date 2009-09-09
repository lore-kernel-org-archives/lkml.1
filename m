Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbZIIBK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbZIIBK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZIIBK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:10:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZIIBK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:10:57 -0400
Date: Tue, 8 Sep 2009 21:09:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: [PATCH 25/23] io-controller: fix queue vs group fairness
Message-ID: <20090909010908.GA5869@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <20090908222827.GC3558@redhat.com> <1252449427.14793.36.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252449427.14793.36.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 03:37:07PM -0700, Daniel Walker wrote:
> 
> patches 25, and 26 both have checkpatch errors.. Could you run them
> through checkpatch and clean up any errors you find?
> 

Sure. Will cleanup those errors in V10 of posting.

Thanks
Vivek
