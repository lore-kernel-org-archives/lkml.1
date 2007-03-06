Return-Path: <linux-kernel-owner+w=401wt.eu-S965765AbXCFCXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965765AbXCFCXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965773AbXCFCXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:23:46 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:4427 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965767AbXCFCXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:23:45 -0500
X-Greylist: delayed 1770 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2007 21:23:45 EST
From: Paul Collins <paul@briny.ondioline.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: francesco foresti <frafore@tiscali.it>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: PROBLEM: 2.6.20-1 not working on ibook g4 (BUG/Oops)
References: <200703051414.15802.frafore@tiscali.it>
	<1173143894.3461.240.camel@pmac.infradead.org>
Date: Tue, 06 Mar 2007 14:53:22 +1300
In-Reply-To: <1173143894.3461.240.camel@pmac.infradead.org> (David Woodhouse's
	message of "Tue\, 06 Mar 2007 01\:18\:14 +0000")
Message-ID: <87tzwzqgrx.fsf@briny.internal.ondioline.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> On Mon, 2007-03-05 at 14:13 +0100, francesco foresti wrote:
>> Hi,
>> i'm having problems trying to use 2.6.20-1 (taken from kernel.org, not 
>> patched) on my ibook g4 (debian testing/unstable): 
>> i'm getting two errors while trying to boot up, and i can only report the 
>> second one because the other slips offscreen before i can see what's going 
>> on. However, this is what i have been able to hand-copy:
>>  
>> kernel BUG at mm/slab.c:610!
>> Oops: Exception in kernel mode, sig: 5 [#2]
[snipped]
> I've been seeing very similar behaviour with 2.6.20 on all pmac32
> hardware. I haven't yet tried hard to reproduce on non-pmac.

In case it's of interest, 2.6.20 has been running fine on my PowerBook5,4.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
