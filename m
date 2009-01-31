Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZAaFSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZAaFSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 00:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbZAaFSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 00:18:07 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:51205 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZAaFSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 00:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TRWtPG+hhil1YA/BaCoOQAWpIn29G9FNU9PxpcmN+hgD/MopK/bh6VnWAALFJCPN/G
         e65ugisiNFuJJ69c+raU+4Blzk+bTw7AaTwo4AdMkvHvZUHdDPY/KXOBxbFdfpZnt6j3
         VCiN2iqWMGEqscYo9zxKRMZUOn4b+eHo+EOQ0=
Message-ID: <4983DF0A.6030402@gmail.com>
Date: Fri, 30 Jan 2009 23:18:02 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartosz SKOWRON <getxsick@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: libata - anomaly performance with NCQ
References: <77887e110901301623u746535f2q7dcc37cd40d2cc56@mail.gmail.com> <4983A446.5080809@shaw.ca> <77887e110901301725p64f5ab4fk341a9bfaf6715a7b@mail.gmail.com>
In-Reply-To: <77887e110901301725p64f5ab4fk341a9bfaf6715a7b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartosz SKOWRON wrote:
> On Sat, Jan 31, 2009 at 2:07 AM, Robert Hancock <hancockr@shaw.ca> wrote:
> 
>>> 1) cause the title contains "with hdparm"...does it mean that
>>> physically the performance is OK and only hdparm shows something
>>> wrong?
>> Well, hdparm is a fairly crude benchmark but there's likely at least some
>> impact in other usage.
> 
> It's not an answer for my question. So, should I check with other
> benchmarks? I thought that this's issue is investigated and the answer
> is common. Do you recommend any "not crude" benchmarks? :)

bonnie++ is one I've used, I'm sure there are others.. Of course, what 
do you compare the results to..

> 
> 
>>> 2) there is an information about upgrading firmware. as far as i know
>>> Seagate doesn't publish firmwares. So the only way is to contact
>>> seagate support, send the hdd and wait for the new one?
>> I think Seagate can provide firmware updaters for the user to use, but
>> normally only if you contact support I think.
> 
> I will send the email cause there is no phone line for my country.
> BTW. upgrade firmware == damage data?

It shouldn't, but some people with the recent 7200.11 drives that did 
firmware upgrades reported it bricked the drive, so backing up the data 
first would definitely be a good idea..
