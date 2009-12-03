Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZLCVcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZLCVcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZLCVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:32:10 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:62288 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZLCVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:32:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XccmQ3m37RnxLESPY9IqyNhWC3G7Uapum03IDiurVES8C3wbLp35UVeYks7+UQUyn7
         SEMr5ArnqzgbyhnEivtLAlJD3+vlNA0AUsIMZZRzVuVlEeJSTIpIyoreHT8PIPHU9Oip
         n/lTBtOvvrEba+cXgQpyU7fFHmJCjkgvAlLC4=
Message-ID: <4B182E5D.2020905@garzik.org>
Date: Thu, 03 Dec 2009 16:32:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <4B1771CD.3090409@garzik.org>	<20091203165947.13841802@lxorguk.ukuu.org.uk>	<4B17F7E4.9040302@garzik.org> <20091203.124804.168589603.davem@davemloft.net>
In-Reply-To: <20091203.124804.168589603.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 03:48 PM, David Miller wrote:
> From: Jeff Garzik<jeff@garzik.org>
> Date: Thu, 03 Dec 2009 12:39:48 -0500
>
>> On 12/03/2009 11:59 AM, Alan Cox wrote:
>>>> The merge window is upon us, which by strict rules means that anything
>>>> not already in libata-dev.git#upstream needs to wait until 2.6.34.
>>>
>>> Not quite yet - Linus hasn't said "go"
>>
>> He rarely if ever says "go."  The kernel X is released, and people
>> send pull requests to Linus for X+1.  He typically merges immediately,
>> but does not push out the first set of merges for a few days.
>
> I don't think he even starts pulling until 1 or 2 days later.
>
> I personally never send him a pull request until a day or two in.

<shrug>  In the past he has commented on pulls, indicating some sort of 
immediate action, yet not pushed for a few days.

Not a big deal.  Plenty of other people send pull requests immediately, 
even if you ignore the high-volume Ingo special case <chuckle>

In any case, the basic point is that Linus does not say "go" for merge 
windows.  People send, he pulls when he chooses, and pushes when he 
chooses.  It's all very zen ;-)

	Jeff




