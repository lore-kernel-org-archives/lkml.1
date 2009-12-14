Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbZLNQZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbZLNQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbZLNQZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:25:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:34510 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757838AbZLNQZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:25:14 -0500
X-Authenticated: #3453474
X-Provags-ID: V01U2FsdGVkX18FTE0i50kFPCvbvhd5fb1mUxgWfYgNyV39n910wH
	Ak5EBEpUQeZvo3
Message-ID: <4B2666EB.8060004@gmx.net>
Date: Mon, 14 Dec 2009 17:25:15 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bug 14594: fix for 2.6.31.8 ?
References: <4B265FEC.6060503@gmx.net> <20091214160416.GA30055@kroah.com>
In-Reply-To: <20091214160416.GA30055@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH schrieb:
> On Mon, Dec 14, 2009 at 04:55:24PM +0100, Frank Schaefer wrote:
>   
>> Bug 14594 has been fixed with commit
>> e29d4363174949a7a4e46f670993d7ff43342c1c for 2.6.32 a month ago, but
>> 2.6.28 - 2.6.31.7 are still affected.
>> Any plans to apply this at least for 2.6.31.8, too ?
>>     
>
> It was never sent to the stable@kernel.org alias so how would I know to
> apply this?
>   
I suspected that... no problem.
Btw, am I the one who is supposed to close this bug, too ? ;)

> I'll queue it up for the next round.
>
> thanks,
>
> greg k-h
>   
Thanks,
Frank Schaefer
