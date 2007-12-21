Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbXLUPhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbXLUPhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 10:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbXLUPhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 10:37:07 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:38892 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbXLUPhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 10:37:06 -0500
Message-ID: <476BDDA1.4040302@davidnewall.com>
Date: Sat, 22 Dec 2007 02:07:05 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jengelh@computergmbh.de, herbert@gondor.apana.org.au,
       alan@lxorguk.ukuu.org.uk, joe@perches.com, apw@shadowen.org,
       lizf@cn.fujitsu.com, akpm@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
References: <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>	<20071221.021236.267832858.davem@davemloft.net>	<476BC2EB.3060000@davidnewall.com> <20071221.060125.165132180.davem@davemloft.net>
In-Reply-To: <20071221.060125.165132180.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: David Newall <david@davidnewall.com>
> Date: Sat, 22 Dec 2007 00:13:07 +1030
>> David Miller wrote:
>>     
>>> From: Jan Engelhardt <jengelh@computergmbh.de>
>>> Date: Fri, 21 Dec 2007 11:10:38 +0100 (CET)
>>>   
>>>       
>>>> Can we get back to programming?
>>>>         
>> With respect to the vast majority of log messages, nobody confounded by 
>> punctuation is truly trying to analyze a problem!
>>     
>
> And nobody confounded by whitespace and coding style is truly
> interesting in writing properly functioning code!
>   

I supposed you meant "interested."  Proper coding style doesn't make for 
proper code.  Arguably, it aids when reading code, and that's why we 
mostly stick to agreed standards; but it's hard to get worked up over a 
dot at the end of a log message.  In cases where it really does matter, 
we make sure it's right; but demanding that every message meets some 
unilateral idea of what is right is zealotry.
