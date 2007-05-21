Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbXEUVpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbXEUVpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbXEUVpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:45:33 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:41602 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbXEUVpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:45:32 -0400
Message-ID: <46521165.5030207@cosmosbay.com>
Date: Mon, 21 May 2007 23:38:45 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, Chuck@hera.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/69] -stable review
References: <20070521191612.800400000@sous-sol.org> <20070521123148.a3dad5f2.akpm@linux-foundation.org> <20070521203111.GJ3429@sequoia.sous-sol.org>
In-Reply-To: <20070521203111.GJ3429@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 21 May 2007 23:38:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright a écrit :
> * Andrew Morton (akpm@linux-foundation.org) wrote:
>> On Mon, 21 May 2007 12:16:12 -0700
>> Chris Wright <chrisw@sous-sol.org> wrote:
>>
>>> This is the start of the stable review cycle for the 2.6.21.2 release.
>> Gee a lot of these are fixing recently-added regressions :(
>>
>> Did we fix oprofile on x86_64 yet?  If not, I'd suggest we should
>> hold off 2.6.21.2 until we have done so.
> 
> No, we've seen 2 versions of the patch, no word from Andi, and nothing
> upstream that I saw.  Andi?
> 

Seems Linus tree includes a fix from Andi, check commit 
6c977aad03a18019015035958c65b6729cd0574c

Probably good enough for 2.6.21.2 ?


