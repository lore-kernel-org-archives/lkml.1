Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbYHUKaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbYHUKaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbYHUKaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:30:05 -0400
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:54507 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYHUKaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:30:04 -0400
Message-ID: <48AD43A6.8090606@numericable.fr>
Date: Thu, 21 Aug 2008 12:29:58 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008081609)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       akpm@osdl.org
Subject: Re: [2.6.27-rc4] compilation warnings and section mismatches
References: <48AD2701.2000304@numericable.fr> <20080821104307.346cbcb7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080821104307.346cbcb7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 21 Aug 2008 10:27:45 +0200
> Rufus&  Azrael<rufus-azrael@numericable.fr>  wrote:
>
>    
>> Hi all,
>>
>> Here are my compilation warnings and section mismatches when building
>> the fresh rc4 kernel version.
>>
>> Hope it could help you to fix.
>>      
>
> All harmless
>
> And patches to the skfp one have been posted repeatedly so I've no idea
> why they are still not in 2.6.27-rc - has Mr Garzik disappeared because
> some of the ATA ones are missing too like the LBA48 off by one fix ?
>
> Alan
>
>    
Thanks for your explanation Alan, but for the skfp warning I just find 
this post on lkml without patch attached :

http://lkml.org/lkml/2008/7/31/145

Do you know if this patch was merged in a git tree and wich one ?

Regards.
