Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZDPJP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZDPJP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZDPJPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:15:47 -0400
Received: from atlanta.zankel.net ([69.61.78.146]:4407 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZDPJPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:15:47 -0400
Message-ID: <49E6F740.8010005@zankel.net>
Date: Thu, 16 Apr 2009 02:15:44 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <jw@emlix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Xtensa patches
References: <1239702080-14355-1-git-send-email-jw@emlix.com>	<49E6E155.6090000@zankel.net>	<20090416012447.fd6e6dee.akpm@linux-foundation.org> <20090416183543.d60521e6.sfr@canb.auug.org.au>
In-Reply-To: <20090416183543.d60521e6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Rothwell wrote:
> On Thu, 16 Apr 2009 01:24:47 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Thu, 16 Apr 2009 00:42:13 -0700 Chris Zankel <chris@zankel.net> wrote:
>>
>>> Hi Andrew,
>>>
>>> I will look over those patches and commit them to xtensa-2.6.
>>>
>> OK.  I have a random pile if i-dont-know-what xtensa stuff here.
> 
> Interestingly, there is an xtensa tree in linux-next that tracks the
> master branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/czankel/xtensa-next.git.
> It hasn't been updated since January ...

Should be updated now. There are a ton of patches outstanding, but they 
are tracked in a different tree somewhere else and require some heavy 
lifting to clean up.


What 'random pile' do you still have there that hasn't been merged, yet?

Thanks,
-Chris
