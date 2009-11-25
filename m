Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZKYHjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZKYHjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZKYHja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:39:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:33578 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZKYHja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:39:30 -0500
Message-ID: <4B0CDEE0.3020308@kernel.org>
Date: Wed, 25 Nov 2009 16:38:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: peterz@infradead.org, torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
Subject: Re: [PATCHSET] workqueue: prepare for concurrency managed workqueue,
 take#3
References: <1258993624-28735-1-git-send-email-tj@kernel.org>
In-Reply-To: <1258993624-28735-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset has been pushed out to linux-next via wq#for-next.  This
patchset will NOT be submitted for merge when 33 -rc1 window opens.
I'm aiming for 34 merge.

Thanks.

-- 
tejun
