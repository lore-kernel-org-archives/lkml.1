Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbXERQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbXERQ7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbXERQ7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:59:50 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:54256 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbXERQ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:59:49 -0400
Date: Fri, 18 May 2007 17:59:48 +0100 (IST)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: "H. Peter Anvin" <hpa@zytor.com>
cc: young dave <hidave.darkstar@gmail.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
In-Reply-To: <464DDA40.6010101@zytor.com>
Message-ID: <Pine.LNX.4.64.0705181756010.1125@skynet.skynet.ie>
References: <20070515201914.16944e04.akpm@linux-foundation.org> 
 <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> 
 <a8e1da0705180154v37e8ec5fs2cc4de9417cd44d2@mail.gmail.com>
 <a8e1da0705180307m60a91996r91c8bfcd1c863a94@mail.gmail.com> <464DDA40.6010101@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, H. Peter Anvin wrote:

> young dave wrote:
>> Hi,
>>
>> After installation the new mm1 kernel, My system can not boot, the rc1
>> kernel works ok.
>>
>> The cursor just blinks after appearing "Bios data check successful"
>> message.
>>
>> what do you think about this?
>
> "Bios data check successful" is not a message that comes from Linux, nor
> from the boot loader.
>
> Since you have left absolutely zero details about your system or
> anything else, there isn't much anyone can do about it.
>

It sounds vagely similar to the silent failure on elm3b132. I'm still 
bisecting this on the side. It's taking an age because the target machine 
is so slow and using a faster machine with a different compiler does not 
reproduce the problem. I don't think it's git-newsetup that is the problem 
though for what that's worth.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
