Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYKEB4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYKEB4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 20:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYKEB4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 20:56:30 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41220 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752538AbYKEB4a (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 20:56:30 -0500
Message-ID: <4910FCF8.5080802@sgi.com>
Date: Wed, 05 Nov 2008 12:55:04 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: david@lang.hm, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.28
References: <20081031045737.ECE0E58AE1E9@chook.melbourne.sgi.com>	 <alpine.DEB.1.10.0810302201030.3116@asgard.lang.hm> <f488382f0810302253l6e8b2705u29582f348256a91a@mail.gmail.com>
In-Reply-To: <f488382f0810302253l6e8b2705u29582f348256a91a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Noonan wrote:
> On Thu, Oct 30, 2008 at 10:02 PM,  <david@lang.hm> wrote:
>> On Fri, 31 Oct 2008, Lachlan McIlroy wrote:
>>
>>> The following changes since commit
>>> 721d5dfe7e516954c501d5e9d0dfab379cf4241a:
>>>  Linus Torvalds (1):
>>>       Merge branch 'for-linus' of git://neil.brown.name/md
>> I am a fairly heavy user of XFS and am as eager as anyone to see cleanups
>> and improvements, but 102 commits to go into -rc3????
>>
>> David Lang
>>
> 
> I'm pretty sure these won't be accepted until 2.6.29's merge window
> opens. The merge window for 2.6.28 has closed, and due to the sheer
> number of commits, at least -one- is bound to cause a regression.

Okay, that's fine.  The tree was too unstable to request a pull any earlier
and we're still chasing some issues.  We should be well and truly ready for
2.6.29.

> 
> - Steven
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
