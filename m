Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZALCMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZALCMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 21:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZALCMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 21:12:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52859 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZALCMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 21:12:16 -0500
Message-ID: <496AA70E.2040704@cn.fujitsu.com>
Date: Mon, 12 Jan 2009 10:12:30 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: David Miller <davem@davemloft.net>, jaswinderlinux@gmail.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de, corbet@lwn.net
Subject: Re: Who wrote 2.6.28
References: <496224D7.2030109@cn.fujitsu.com> <3f9a31f40901090609n29b4e36dwe6fff7fdfc705c7e@mail.gmail.com> <20090109.141124.154196743.davem@davemloft.net> <20090111183007.GB2217@ucw.cz>
In-Reply-To: <20090111183007.GB2217@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek said the following on 2009-1-12 2:30:
> On Fri 2009-01-09 14:11:24, David Miller wrote:
>> From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
>> Date: Fri, 9 Jan 2009 19:39:17 +0530
>>
>>> In http://remword.com/kps_result/2_6_29_whole_line.html
>>> Earlier I was using email address: Jaswinder Singh
>>> <jaswinder@infradead.org> (Unknown #25) and now I am using:
>>> Jaswinder Singh Rajput <jaswinderrajput@gmail.com> (Unknown #25)
>>>
>>> If possible can you link above two emails.
>> This reminds me that I noticed another one that needs linking,
>> shemminger@linux-foundation.org became shemminger@vyatta.com
> 
> Hmmm, should those go to linux/.mailmap ? Heh, add pavel@ucw.cz ==
>  pavel@suse.cz ....
> 

It's already done by my statistic tool by following merge code:
	CONV_PER_ITEM("<pavel@ucw.cz>",
			"<pavel@suse.cz>", "Novell"),
	CONV_PER_ITEM("<pavel@pavel@suse.cz>",
			"<pavel@suse.cz>", "Novell"),
	CONV_PER_ITEM("<pavel@suse.de>",
			"<pavel@suse.cz>", "Novell"),
	CONV_PER_ITEM("<pavel@suze.cz>",
			"<pavel@suse.cz>", "Novell"),
seems you've used some typo addresses in history ;)
