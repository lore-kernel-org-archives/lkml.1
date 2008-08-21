Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbYHUK7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbYHUK7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYHUK7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:59:24 -0400
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:35927 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYHUK7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:59:24 -0400
Message-ID: <48AD4A89.1050603@numericable.fr>
Date: Thu, 21 Aug 2008 12:59:21 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008081609)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       akpm@osdl.org
Subject: Re: [2.6.27-rc4] compilation warnings and section mismatches
References: <48AD2701.2000304@numericable.fr>	<20080821104307.346cbcb7@lxorguk.ukuu.org.uk>	<48AD43A6.8090606@numericable.fr> <20080821113736.5cd7368b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080821113736.5cd7368b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> http://lkml.org/lkml/2008/7/31/145
>>
>> Do you know if this patch was merged in a git tree and wich one ?
>>      
>
> Look for " [PATCH] drivers/net/skfp/pmf.c: Use offsetof() macro"
>
>
>    
Yes Alan, I have found it at Marc ML and BTW I find this one for

> drivers/net/skfp/ess.c: In function 'ess_send_response':
> drivers/net/skfp/ess.c:513: warning: cast from pointer to integer of different size
> drivers/net/skfp/ess.c: In function 'ess_send_alc_req':
> drivers/net/skfp/ess.c:609: warning: cast from pointer to integer of different size
> drivers/net/skfp/ess.c:639: warning: cast from pointer to integer of different size
>    
http://marc.info/?l=linux-kernel&m=121752329426586&w=2

Could you make in sort these two patches could be merged in next rc ?

Thanks in advance.
