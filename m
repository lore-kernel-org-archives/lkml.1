Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZDVNRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZDVNRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZDVNRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:17:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49883 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbZDVNRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:17:04 -0400
Date: Wed, 22 Apr 2009 15:17:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
Message-ID: <20090422131703.GO4593@kernel.dk>
References: <20090421184223.GP19637@balbir.in.ibm.com> <49EE42CC.7070002@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EE42CC.7070002@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21 2009, Steve Wise wrote:
>
>
> Balbir Singh wrote:
>> Hi, Andrew,
>>
>> I did a quick check on lkml to see if someone reported this issue
>> already, I could not find any reports. I am beginning to see several
>> of these on my machine. I saw recent refactoring of rbtrees, I've
>> cc'ed Wolfram Strepp.
>>
>>   
>
>
> I see a similar crash (null ptr deref in rb_erase()) booting up  
> 2.6.30-rc2/x86_64/centos 5.3 distro.

Plain 2.6.30-rc2? Please also post the oops, thanks!

-- 
Jens Axboe

