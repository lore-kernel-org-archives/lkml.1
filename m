Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZKQQRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZKQQRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZKQQRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:17:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:39329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZKQQRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:17:23 -0500
Message-ID: <4B02CC70.4050703@kernel.org>
Date: Wed, 18 Nov 2009 01:16:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, andi@firstfloor.org,
       fweisbec@gmail.com
Subject: Re: [PATCH 04/21] sched: implement scheduler notifiers
References: <1258391726-30264-1-git-send-email-tj@kernel.org>	 <1258391726-30264-5-git-send-email-tj@kernel.org>	 <1258396864.4372.55.camel@twins>  <4B019FC9.4080309@kernel.org> <1258403365.3961.15.camel@laptop>
In-Reply-To: <1258403365.3961.15.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/17/2009 05:29 AM, Peter Zijlstra wrote:
>>  we can have sleep/ready/run hooks instead.
> 
> I would much prefer that, sleep/ready are significantly different from
> deactivate/activate.

Alright, will update.

Thanks.

-- 
tejun
