Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZBDDSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZBDDSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZBDDSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:18:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:33748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZBDDSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:18:30 -0500
Message-ID: <498908F9.9040901@kernel.org>
Date: Wed, 04 Feb 2009 12:18:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <4983E5D3.3040100@kernel.org> <200902021934.14168.rusty@rustcorp.com.au>
In-Reply-To: <200902021934.14168.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Feb 2009 03:18:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 31 January 2009 16:16:59 Tejun Heo wrote:
>> Anyways, please pull from
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> Thanks.  cpualloc patches rebased on top of it (I had to include the module
> patch I've got queued for 2.6.29, otherwise gratuitous conflicts):
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/tj-percpu-cpualloc master
> 
> Boot tested here, but that's no guarantee that something didn't break.
> 
> I'm going to be occupied with finishing off cpumask_t this cycle, so I'd be
> happy for you to take ownership of any and all of these that you want to keep.
> I'll try to keep up with other patches as you post them.

Will merge it in this week.

Thanks.

-- 
tejun
