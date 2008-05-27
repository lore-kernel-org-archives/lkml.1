Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYE0RwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYE0RwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbYE0Rvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:51:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:39481 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbYE0Rvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vJ9h+OTgv2d97Et9qLVS8OlM9l1To85O3UoVeabUXTPsh8yjmV2AQm8BKbT3P/7tSFMGHgiVE4/eP/jnzJZfA7L7Tgp4I8Awv2dD/G77R0zRbaC7hR4JUQAZkySXSnOQQYiCXHsPXw7ZQLQuYLcVUQ8hX4btb08caHHQIE7C5bo=
Message-ID: <dd18b0c30805271051p7c4c6baeqf26db3bdbb7182ed@mail.gmail.com>
Date: Tue, 27 May 2008 17:51:47 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: appletouch after wakeup
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <2c0942db0805270806r35bdceejb0aa1535f001b7a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805262029me288690y237f995fb63ccf54@mail.gmail.com>
	 <200805271040.44203.oliver@neukum.org>
	 <dd18b0c30805270804p454a8fd9x2a0484c482c89440@mail.gmail.com>
	 <2c0942db0805270806r35bdceejb0aa1535f001b7a9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 3:06 PM, Ray Lee <ray-lk@madrabbit.org> wrote:
> On Tue, May 27, 2008 at 8:04 AM, Justin Mattock <justinmattock@gmail.com> wrote:
>> On Tue, May 27, 2008 at 8:40 AM, Oliver Neukum <oliver@neukum.org> wrote:
>>> Am Dienstag, 27. Mai 2008 05:29:04 schrieb Justin Mattock:
>>>> Hello; with 2.6.26-rc3 I've notice appletouch is going out of whack,
>>>> here's what I see after waking the machine from suspend,
>>>> [ 8186.661313] appletouch: incomplete data package (first byte: 2, length: 4).
>>>> Keep in mind there is not just one of these messages, the entire dmesg
>>>> is filled.
>>>
>>> Immediately after resumption? STR or STD?
>>>
>>>        Regards
>>>                Oliver
>>>
>>>
>>
>> I have to admit I don't know what STR or STD is for computer terminology!!
>> regards;
>
> STR == Suspend To RAM, STD == Suspend To Disk
>
> Ray
>

Something so simple, yet so difficult. Then to answer the question
properly it would be STR or
echo mem > /sys/power/state
regards;
-- 
Justin P. Mattock
