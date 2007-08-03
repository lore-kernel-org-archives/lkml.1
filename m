Return-Path: <linux-kernel-owner+w=401wt.eu-S1763620AbXHCVBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763620AbXHCVBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760670AbXHCVBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:01:09 -0400
Received: from dsl.myri.com ([64.172.73.26]:2017 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758221AbXHCVBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:01:08 -0400
Message-ID: <46B39774.4050909@myri.com>
Date: Fri, 03 Aug 2007 17:00:36 -0400
From: Andrew Gallatin <gallatin@myri.com>
User-Agent: Thunderbird 1.5.0.7 (Macintosh/20060909)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com, jeff@garzik.org,
       davem@davemloft.net
Subject: Re: [PATCH] lro: myri10ge example how to use LRO
References: <46B363A8.4010407@myri.com> <46B39063.6070301@intel.com>
In-Reply-To: <46B39063.6070301@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Andrew Gallatin wrote:
>> To follow up on Jan-Bernd Themann's LRO patch earlier today,
>> this patch shows how the generic LRO interface can be used for
>> page based drivers.
>>
>> Again, many thanks to Jan-Bernd Themann for leading this effort.
>>
>> Drew
>>
>> Singed off by: Andrew Gallatin <gallatin@myri.com>
>>
> 
> 
> please take a look at my lro patch for ethtool and see if it works for 
> you, instead of adding another generic module parameter that doesn't 
> need to be there.

That looks very nice, and will indeed work for me.

Thanks,

Drew
