Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZA2TdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZA2TdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZA2Tcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:32:51 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:35285 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZA2Tcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=S8gGvLJW19FyW70vBaMxfURFc6C7liKyVROCeVgmsLDsaaJthF7p0D18Lmx69lB0YI
         LyO6P93RxXsSItIgFfmaNx0+ofweLxhsErMZE9vkF9eyWQVB9EeugRa4aWkb1LR7xKwL
         rSDXZCbT6sylWrColLd2tMKY6Kn2iK4QwtC4o=
Message-ID: <4982045B.6090206@gmail.com>
Date: Thu, 29 Jan 2009 11:32:43 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: macbook pro radeon suspend issue
References: <49812E3B.6050106@gmail.com> <200901291536.37348.rjw@sisk.pl>
In-Reply-To: <200901291536.37348.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 29 January 2009, Justin P. Mattock wrote:
>   
>> No sure if there is a bug report already or not.
>> For the macbook pro(ATI chipset) suspend is broken.
>> As for kernel version: latest git.
>> Last week(before LCA, and during the week, since being no merges.)
>> the system would wakeup, show a black screen and sit there. Now
>> after a couple of merges have been completed The system wakes up,
>> but instantly reboot's.
>>
>> I tried to supply any info(ohci1394_dma) when the wakeup occurs, but had 
>> no response
>> for some reason or another.
>> I can try and do a bisect, the only problem
>> I have though, is I never labeled good/bad commits(forgot how too);
>>
>> In any case If I'm in an urgent need, of having  to suspend
>> the system(not in anytime soon at the moment),
>> then Ill just revert kernels to one that I know works.     :^)
>>     
>
> Which is that?
>
> Rafael
>
>   
O.K. I ended up grabbing the packages from debian
to get it working.

regards;

Justin P. Mattock
