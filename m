Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYDXDDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYDXDDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 23:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYDXDDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 23:03:41 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2811 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYDXDDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 23:03:41 -0400
Message-ID: <480FF883.7030708@linuxtv.org>
Date: Wed, 23 Apr 2008 23:03:31 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       ivtv-devel@ivtvdriver.org, biercenator@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
References: <480F7A0E.2080202@linuxtv.org> <Pine.LNX.4.64.0804232210550.31358@bombadil.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0804232210550.31358@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
>>>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>>>
>>> In this case, it should be reviewed-by.
>>>
>>> I should be sending this soon to Linus.
>>
>>
>> Mauro,
>>
>> I think it's wrong that you alter signatures.  You did this:
>>
>> Reviewed-by: <mkrufky@linuxtv.org <mailto:mkrufky@linuxtv.org>>
>
> Argh! I didn't notice that weird stuff. This should be fixed before
> forwarding the patch. Sorry for the mess.
>
> [snip]
>
> After the merge at mainstream, you'll send this to stable. In this
> case, you'll take it from my tree, add your SOB, and forward it.
>
> Unfortunately, it is a common mistake of people sending SOB's instead
> of acked-by or reviewed-by, so several maintainers warns about the
> improper usage of the tags and corrects it on their trees, or simply
> ignores such improper usage.

Good point.
>
> If you prefer, I may just drop the tag from my tree, or fix the
> "reviewed-by".

Perhaps it makes most sense to just drop my tag, in this case  -- that's
fine with me.

Regards,

Mike
