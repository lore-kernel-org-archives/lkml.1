Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZBEAgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZBEAgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZBEAfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:35:54 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:15816 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760728AbZBEAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:35:52 -0500
Message-ID: <498A3465.80405@chelsio.com>
Date: Wed, 04 Feb 2009 16:35:49 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, kxie@chelsio.com
Subject: Re: [PATCH 2.6.29] cxgb3 - Fix lro switch
References: <20090205002547.26126.47373.stgit@speedy5> <20090204.163250.127196315.davem@davemloft.net>
In-Reply-To: <20090204.163250.127196315.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2009 00:36:26.0890 (UTC) FILETIME=[C7996EA0:01C98729]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Divy Le Ray <divy@chelsio.com>
> Date: Wed, 04 Feb 2009 16:25:47 -0800
>
>   
>> The LRO switch is always set to 1 in the rx processing loop.
>> It breaks the accelerated iSCSI receive traffic.
>> Fix its computation.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>>     
>
> Applied, thank you.
>
> Could you slightly reformat your Subject lines for patches?  Please
> use something like "cxgb3: $(description)" instead of the "cxgb3 -
> $(description)" you're using now.
>
> It'll be one less thing I need to edit when applying your
> patches :-)
>   

Sorry about that. I'll use this format from now on.

cheers,
Divy
