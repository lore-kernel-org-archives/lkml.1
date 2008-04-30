Return-Path: <linux-kernel-owner+w=401wt.eu-S1762729AbYD3THu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762729AbYD3THu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760323AbYD3THk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:07:40 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:58145 "EHLO
	zcars04f.ca.nortel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759955AbYD3THj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:07:39 -0400
Message-ID: <4818C336.5000800@nortel.com>
Date: Wed, 30 Apr 2008 13:06:30 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Newall <davidn@davidnewall.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <4817EF91.4080800@davidnewall.com> <20080429.211835.130816277.davem@davemloft.net> <48186E57.5070805@davidnewall.com> <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org> <4818B8A7.4000902@davidnewall.com> <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Apr 2008 19:06:34.0139 (UTC) FILETIME=[4E894EB0:01C8AAF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 1 May 2008, David Newall wrote:
> 
>>Why are you bringing up git trees (which I don't use)?  I'm presently
>>plagued with a problem that's 2.6.22 or older, extending to at least
>>2.6.23 and maybe still current.
> 
> 
> Ok, *PLONK*.
> 
> You're on an old kernel, don't know if your problem is fixed, and ask us 
> to slow down development.
> 
> That makes sense.
> 
> Go away.

He did say that he was testing 2.6.25, and that suspend-to-disk was 
broken in 2.6.25.

Chris
