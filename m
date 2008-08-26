Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbYHZT7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbYHZT7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYHZT7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:59:05 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:37955 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbYHZT7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:59:04 -0400
Message-ID: <48B46082.3060809@numericable.fr>
Date: Tue, 26 Aug 2008 21:58:58 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008082610)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [2.6.27-rc4-git5] ipv4: sysctl fixes causes "cannot open	/proc/sys/net/ipv4/route/flush"
References: <48B43562.20602@numericable.fr> <48B43A0A.5060406@numericable.fr> <20080826190515.GY28946@ZenIV.linux.org.uk> <20080826190833.GA28946@ZenIV.linux.org.uk>
In-Reply-To: <20080826190833.GA28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Aug 26, 2008 at 08:05:15PM +0100, Al Viro wrote:
>
>    
>> I'm just about to fall down at the moment, will look into that once I get
>> some sleep.  In the meanwhile, .config might be useful...
>>      
>
> See Subject: [PATCH] ipv4: mode 0555 in ipv4_skeleton.  That's practically
> certain to be the fix for the same bug.
>
> Now, where was that brown paperbag...
>
>    
Thanks Al,

Hugh's patch in post http://lkml.org/lkml/2008/8/26/236 works fine and 
the route warning disappears.

Good night :-).

Regards.
