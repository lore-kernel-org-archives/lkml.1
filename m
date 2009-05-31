Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZEaDbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZEaDbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 23:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZEaDbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 23:31:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbZEaDbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 23:31:00 -0400
Message-ID: <4A21FA25.2000007@redhat.com>
Date: Sun, 31 May 2009 11:31:49 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rdunlap@xenotime.net, mingo@elte.hu
Subject: Re: [Patch 2/2] Doc: move Documentation/exception.txt into x86 subdir
References: <20090527072952.6279.72977.sendpatchset@localhost.localdomain>	 <20090527073001.6279.90725.sendpatchset@localhost.localdomain>	 <1243412698.3109.4.camel@localhost.localdomain>	 <4A1CFBCB.8020808@redhat.com> <1243414594.3109.10.camel@localhost.localdomain>
In-Reply-To: <1243414594.3109.10.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>>> What is the reason of this name change exception.txt -> extable.txt
>>>   
>>>       
>> Hello,
>>
>> Because this doc explains how exception tables work on x86, not the 
>> hardware concept
>> "exceptions" of x86 CPU, thus extable.txt is much more reasonable. :)
>>
>>     
>
> In such case you can use exception-tables.txt or
> exception-tables-howto.txt
>   

OK, I will update my patch. :)

Thanks.

