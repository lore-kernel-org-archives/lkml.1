Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYDITI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYDITI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYDITIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:08:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54027 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYDITIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:08:47 -0400
Message-ID: <47FD1431.6050206@garzik.org>
Date: Wed, 09 Apr 2008 15:08:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: =?UTF-8?B?WU9TSElGVUpJIEhpZGVha2kgLyDlkInol6Toi7HmmI4=?= 
	<yoshfuji@linux-ipv6.org>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <47FCC6B5.70804@rtr.ca>	<47FCF2DD.30705@garzik.org>	<47FCF9DD.6080007@rtr.ca> <20080410.023045.16227424.yoshfuji@linux-ipv6.org> <47FD138B.2060801@rtr.ca>
In-Reply-To: <47FD138B.2060801@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> YOSHIFUJI Hideaki / 吉藤英明 wrote:
>> In article <47FCF9DD.6080007@rtr.ca> (at Wed, 09 Apr 2008 13:16:13 
>> -0400), Mark Lord <lkml@rtr.ca> says:
>>
>>> I suppose a wireshark capture is next, once I dig out my ancient hub
>>> so we can sniff it from an independent box.
>>
>> Or, you could do "git-bisect" if it is reproducible.
> ..
> 
> If I had the time right now, maybe.
> 
> But it would be far more useful for whoever has been working on the stack
> to suggest some possible/likely commits to look at instead.

'git bisect run <cmd>' will automatically find your problem for you, if 
it's reproducible, scriptable, and you have a second box.

	Jeff





