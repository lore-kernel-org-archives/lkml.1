Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbZBSC10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbZBSC10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 21:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbZBSC1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 21:27:14 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:12162 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZBSC1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 21:27:13 -0500
Message-ID: <499CC309.3080305@chelsio.com>
Date: Wed, 18 Feb 2009 18:25:13 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.30] cxgb3: Add support for PCI ID 0x35.
References: <20090216044615.24884.9331.stgit@speedy5> <20090218.174835.12982157.davem@davemloft.net>
In-Reply-To: <20090218.174835.12982157.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Feb 2009 02:25:56.0093 (UTC) FILETIME=[64EEC2D0:01C99239]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Divy Le Ray <divy@chelsio.com>
> Date: Sun, 15 Feb 2009 20:46:15 -0800
>
>   
>> Add support for adapters with a PCI id equal to 0x35.
>>
>> Signed-off-by: Divy Le Ray <divy@chelsio.com>
>>     
>
> Adding new IDs is something we can do in net-2.6, so I'm
> going to add this patch there.
>
> Let me know if you don't want me to do that, or if there
> is some dependency with net-next-2.6 that I'm not seeing.
>   

Hi Dave,

Applying it against net-2.6 is all good.

Cheers,
Divy
