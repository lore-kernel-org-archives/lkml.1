Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZKQAIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZKQAIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 19:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZKQAIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 19:08:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:37003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbZKQAIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 19:08:21 -0500
Message-ID: <4B01E96C.9070306@kernel.org>
Date: Tue, 17 Nov 2009 09:08:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, Andi Kleen <ak@linux.intel.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 01/21] workqueue: fix race condition in	schedule_on_each_cpu()
References: <1258391726-30264-1-git-send-email-tj@kernel.org> <1258391726-30264-2-git-send-email-tj@kernel.org> <20091116230427.GD5293@nowhere>
In-Reply-To: <20091116230427.GD5293@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/17/2009 08:04 AM, Frederic Weisbecker wrote:
> Shouldn't this patch go to .32 ?
> This looks like an important fix.

This one and the next one are already on their way to .32.

Thanks.

-- 
tejun
