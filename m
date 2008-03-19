Return-Path: <linux-kernel-owner+w=401wt.eu-S966082AbYCTAJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966082AbYCTAJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937591AbYCSXRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:17:44 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:40110 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942606AbYCSXRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:17:36 -0400
Message-ID: <47E19F0A.1010301@hp.com>
Date: Wed, 19 Mar 2008 16:17:30 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: benoit.boissinot@ens-lyon.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, pekkas@netcore.fi, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] [RFC] [IPv6] spelling fix in /proc:	/proc/sys/net/ipv6/conf/default/temp_prefered_lft
References: <20080319204227.GF6935@ens-lyon.fr> <20080319.135205.125229102.davem@davemloft.net>
In-Reply-To: <20080319.135205.125229102.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
> Date: Wed, 19 Mar 2008 21:42:27 +0100
> 
> 
>>Is there a way to fix a bad spelling in /proc ?
>>
>>Here is a patch to fix all the spelling error (prefered -> preferred)
>>in the ipv6 code. I didn't change the /proc name but everything else is
>>changed.
>>Currently you can found both spelling in the ipv6 code.
>>Is it ok ?
> 
> 
> I think this doesn't add any value.
> 
> If the procfs file name has to remain the same, which it does,
> changing variable and macro names to be different will only
> cause merge conflicts and pain yet have no redeeming value.

I've not split many hairs today so I'll ask - is there _no_ way to 
migrate a name in /proc et al?  While it may be minor to most, it would 
seem that leaving spelling errors out where users see them doesn't 
convey all that positive an image.

rick jones
