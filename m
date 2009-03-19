Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbZCSUkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbZCSUkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZCSUk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:40:29 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:15689 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753776AbZCSUk3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:40:29 -0400
Message-ID: <49C2ADA8.2090405@shipmail.org>
Date: Thu, 19 Mar 2009 21:40:08 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Dave Airlie <airlied@gmail.com>, David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
 changes
References: <20090319040809.GA29249@kroah.com> <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com> <49C21B0B.4060809@shipmail.org> <20090319201136.GB17094@kroah.com>
In-Reply-To: <20090319201136.GB17094@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Mar 19, 2009 at 11:14:35AM +0100, Thomas Hellström wrote:
>   
>>> First off, the non-staging patches need more complete changelog entries,
>>> a bit of meaning goes a long way. I'll ack them if they are documented and
>>> make sense. The unlocked ioctl hook makes sense to me at least!
>>>   
>>>       
>> For the non-staging patches, (which also sit in the modesetting-newttm 
>> tree), I can add some more elaborate comments. However I think all of
>> them are targeted to support functionality for TTM, so unless the TTM
>> code goes into staging or mainstream, there is little point in merging
>> them to core drm before other drivers find them useful.
>>
>> Although I see the patch adding TTM is including some backwards
>> compatibility defines (In particular the PAT compat stuff) that needs
>> to be stripped.
>>     
>
> Great, care to respin it and send it to me?
>
> thanks,
>
> greg k-h
>   
Greg,
A clean TTM patch was sent to Intel with the other patches.
I'm not sure why it got lost along the way?

/Thomas




