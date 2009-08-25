Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZHYFE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZHYFE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 01:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZHYFE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 01:04:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:57395 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZHYFEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 01:04:55 -0400
Message-ID: <4A937093.2010109@kernel.org>
Date: Mon, 24 Aug 2009 22:03:15 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <4A932FD7.5030000@kernel.org> <20090825013801.GC6842@localdomain>
In-Reply-To: <20090825013801.GC6842@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> On Mon, Aug 24, 2009 at 05:27:03PM -0700, Yinghai Lu wrote:
>> Yinghai Lu wrote:
>>> Ravikiran G Thirumalai wrote:
>> can you check if this one fix your problem?
>>
> 
> Nope it doesn't :(

then there is other path

> 
> 
>> BTW: what does your /proc/cpuinfo print about apic id and initial apic id?
>>
> 
> Here's a sample cpuinfo from an older kernel (attached)
> 
> 

why there is two lines cores?

also we should have initial apic id field...

YH
