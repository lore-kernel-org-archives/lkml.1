Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYDITF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYDITF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYDITFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:05:49 -0400
Received: from rtr.ca ([76.10.145.34]:2988 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbYDITFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:05:48 -0400
Message-ID: <47FD138B.2060801@rtr.ca>
Date: Wed, 09 Apr 2008 15:05:47 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: =?UTF-8?B?WU9TSElGVUpJIEhpZGVha2kgLyDlkInol6Toi7HmmI4=?= 
	<yoshfuji@linux-ipv6.org>
Cc: jeff@garzik.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <47FCC6B5.70804@rtr.ca>	<47FCF2DD.30705@garzik.org>	<47FCF9DD.6080007@rtr.ca> <20080410.023045.16227424.yoshfuji@linux-ipv6.org>
In-Reply-To: <20080410.023045.16227424.yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki / 吉藤英明 wrote:
> In article <47FCF9DD.6080007@rtr.ca> (at Wed, 09 Apr 2008 13:16:13 -0400), Mark Lord <lkml@rtr.ca> says:
> 
>> I suppose a wireshark capture is next, once I dig out my ancient hub
>> so we can sniff it from an independent box.
> 
> Or, you could do "git-bisect" if it is reproducible.
..

If I had the time right now, maybe.

But it would be far more useful for whoever has been working on the stack
to suggest some possible/likely commits to look at instead.

-ml
