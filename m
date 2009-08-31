Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbZHaVOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbZHaVOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 17:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZHaVOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 17:14:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbZHaVOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 17:14:43 -0400
Message-ID: <4A9C3CDA.5010301@redhat.com>
Date: Mon, 31 Aug 2009 17:12:58 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 23/23] io-controller: debug elevator fair queuing	support
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-24-git-send-email-vgoyal@redhat.com> <4A9C3951.8020302@redhat.com> <20090831210154.GA8229@redhat.com>
In-Reply-To: <20090831210154.GA8229@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Aug 31, 2009 at 04:57:53PM -0400, Rik van Riel wrote:
>> Vivek Goyal wrote:
>>> o More debugging help to debug elevator fair queuing support. Enabled under
>>>   CONFIG_DEBUG_ELV_FAIR_QUEUING. Currently it prints vdisktime related
>>>   trace messages in blktrace.
>>>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> Is this meant for merging upstream, or just as a temporary
>> debugging help while this sits in a subsystem tree or -mm?
> 
> I think it would be good if this also is merged upstream. A useful
> debugging help to track fairness and latecy related issues.

Fair enough.  The code is small enough, anyway.

Acked-by: Rik van Riel <riel@redhat.com>

