Return-Path: <linux-kernel-owner+w=401wt.eu-S1764666AbYA1X3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764666AbYA1X3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYA1X3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:29:30 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:14914 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbYA1X33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:29:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DEQsxjuiZKoCejNrw6pN9O7817dTvrk/e2emhOxVTcWq08LNbRVJjKX11LFskAKcVpZ2aFHiq8p0mvR3HmBya8HDjrZ1bgQUFQqS/LgHW/jTr32VfnpXS9akWeg0LYqUH3Ruvnn6rs5jr807Uvd4seNemsKUrhtZfZeoTU8rGbQ=
Message-ID: <479E654F.4070804@gmail.com>
Date: Tue, 29 Jan 2008 00:29:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: dsterba@suse.cz, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, benm@symmetric.co.nz,
       stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
References: <20080128171929.GA3906@ds.suse.cz>	<20080128100854.fe7acad8.rdunlap@xenotime.net>	<479E62AB.3010603@gmail.com> <20080128152809.59d1f52a.rdunlap@xenotime.net>
In-Reply-To: <20080128152809.59d1f52a.rdunlap@xenotime.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2008 12:28 AM, Randy Dunlap wrote:
> On Tue, 29 Jan 2008 00:18:03 +0100 Jiri Slaby wrote:
> 
>> On 01/28/2008 07:08 PM, Randy Dunlap wrote:
>>>> +/*
>>>> + * @return 1 if something has been received from hw
>>> What's with the '@'?
>> ...
>>>> +
>>>> +/*!
>>> and the '!' ?
>>>
>>>> + * @return true if the card is physically present.
>>>> + */
>> What exactly is wrong with @ and !? It's perfectly doxygen-styled.
> 
> What part of kernel documentation uses doxygen?

So then, what's the problem?
