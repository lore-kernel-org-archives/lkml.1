Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbZKXNfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbZKXNfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932910AbZKXNfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:35:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbZKXNfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:35:47 -0500
Message-ID: <4B0BE0A0.5030703@redhat.com>
Date: Tue, 24 Nov 2009 15:33:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: peterz@infradead.org, torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net
Subject: Re: [PATCHSET] workqueue: prepare for concurrency managed workqueue,
 take#3
References: <1258993624-28735-1-git-send-email-tj@kernel.org>
In-Reply-To: <1258993624-28735-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 06:26 PM, Tejun Heo wrote:
> Hello, all.
>
> This patchset is the third take of prep-for-concurrent-managed-wq
> patchset.
>    


The kvm and sched_notifier changes are fine as far as I'm concerned.

-- 
error compiling committee.c: too many arguments to function

