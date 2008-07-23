Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbYGWISP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbYGWISP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 04:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYGWISE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 04:18:04 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1946 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750774AbYGWISD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 04:18:03 -0400
Message-ID: <4886E932.1010206@myri.com>
Date: Wed, 23 Jul 2008 10:17:54 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression: myri10ge driver in 2.6.26
References: <20080722150438.GK4359@ics.muni.cz> <48865B04.6030707@myri.com> <488664A0.3040407@myri.com> <20080723080638.GL4359@ics.muni.cz>
In-Reply-To: <20080723080638.GL4359@ics.muni.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> On Wed, Jul 23, 2008 at 12:52:16AM +0200, Brice Goglin wrote:
>   
>>> I have seen one machine with a similar problem. Does reverting
>>> 014377a1df693ff30a9e8b69f0bbb0a38e601f75 help? Also could you check that
>>> current Linus' git works fine? (just get the driver source from there,
>>> no need to build the whole tree)
>>>   
>>>       
>> If the above is correct, then patch below should fix it. If so, I'll
>> push this into the next stable 2.6.26.x release.
>>     
>
> did not try to revert the mentioned patch but your attached patch made the
> kernel driver working. So, please push it into the next stable.
>   


Thanks for testing, I just sent the patch to stable@

Brice

