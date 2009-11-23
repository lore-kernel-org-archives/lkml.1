Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZKWBsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZKWBsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 20:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZKWBsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 20:48:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:59620 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbZKWBsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 20:48:30 -0500
Message-ID: <4B09EA08.1020903@kernel.org>
Date: Mon, 23 Nov 2009 10:48:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
Subject: Re: [PATCHSET] workqueue: prepare for concurrency managed workqueue,
 take#2
References: <1258692407-8985-1-git-send-email-tj@kernel.org>	 <4B07608B.7020002@kernel.org> <1258805279.4104.923.camel@laptop>
In-Reply-To: <1258805279.4104.923.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/21/2009 09:07 PM, Peter Zijlstra wrote:
>> I'm pushing out 0001-0014 to linux-next via the following tree.

The sched fix patch hasn't showed up in upstream so I didn't do it
yet.

>> I intend to keep the tree stable from this point on unless drastic
>> change is necessary.  I'll posting further patches against the above
>> tree.
> 
> 05 is a full nak and needs reimplementing.
> 06 at the very least needs a changelog.

Alright, one more round to go then.

Thanks for reviewing.

-- 
tejun
