Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123Ab0ARJku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0ARJku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841Ab0ARJkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:40:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0ARJks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:40:48 -0500
Message-ID: <4B542C99.9000801@suse.cz>
Date: Mon, 18 Jan 2010 10:40:41 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] kbuild: improve version string logic
References: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com> <4B4345AF.9040600@suse.cz> <alpine.DEB.2.00.1001131300360.26527@chino.kir.corp.google.com> <20100116063754.GC20342@elte.hu> <20100116183445.29fc5d50.sfr@canb.auug.org.au> <20100116092658.GA23999@elte.hu>
In-Reply-To: <20100116092658.GA23999@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.1.2010 10:26, Ingo Molnar wrote:
> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi Ingo,
>>
>> On Sat, 16 Jan 2010 07:37:54 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> Given that Sam doesnt maintain the kbuild tree anymore, would this patch be a 
>>> good fit for -mm perhaps?
>>
>> There is a new kbuild tree maintainer: Michal Marek <mmarek@suse.cz>
> 
> Good. Michal, what do you think about David's patch?

The patch is OK, I already commented on a previous version and this
addresses the two minor issues I had. I was just too busy last week to
apply it. I will do so ASAP now.

Michal
