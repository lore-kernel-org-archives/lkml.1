Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbYDLBIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbYDLBIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 21:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYDLBHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 21:07:52 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:43467 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756578AbYDLBHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 21:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hwJsV8qA7UDZEk5dhjhbqkqO9WhMxT0i1VWEHw0QohoXUWIMDjCQ3vO/wZ5aqkhaNKnly+4BhESyuLig2w1zxraRguHmcMkqGhfwDDiK2RzIp0mA7dRzVzvKbDY6B7+9RAE9AvIc7nlNfanMC3jWiAdco6+SeSptRR5gDHkilvk=
Message-ID: <48000B55.7040000@gmail.com>
Date: Sat, 12 Apr 2008 10:07:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Adrian Bunk <bunk@kernel.org>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make ali_atapi_dma static
References: <20080411172827.GC25788@cs181133002.pp.htv.fi> <20080411193608.16e7147b@core>
In-Reply-To: <20080411193608.16e7147b@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 11 Apr 2008 20:28:27 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
>> This patch makes the needlessly global ali_atapi_dma static.
>>
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Acked-by: Alan Cox <alan@redhat.com>

Acked-by: Tejun Heo <htejun@gmail.com>

What was I thinking?

-- 
tejun
