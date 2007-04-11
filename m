Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXDKP4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXDKP4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXDKP4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:56:40 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:21062 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753154AbXDKP4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:56:39 -0400
Message-ID: <461D0560.8090801@ru.mvista.com>
Date: Wed, 11 Apr 2007 19:57:20 +0400
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
References: <461A4C1E.3070309@ru.mvista.com>	<20070410102111.923b92a9.dada1@cosmosbay.com>	<461CCD94.6010507@ru.mvista.com> <20070411161536.926d79e1.dada1@cosmosbay.com> <461CFFD7.4010304@tmr.com>
In-Reply-To: <461CFFD7.4010304@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:

> [snip]
>
>>
>> Your description is not very clear about the semantic of your stats.
>>
>> You currently returns stats only for thread(s) (not process as you 
>> claimed)
>>   
>
> I'm not sure if you were confused by his use of thread in parenthesis, 
> but isn't the whole point of this to see which threads are doing what? 
> Or am I misreading his result as intentional?

Yes the point is to get some statistics from thread in other words to 
see which threads are doing what.
