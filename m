Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZEULhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZEULhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZEULg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:36:57 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:37326 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbZEULg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=hFtLKsp+HMHnEpFwGG8ZsQ5ijifxmTJ/2lmWDW+gOK1/kiymrKTvO8nFwEIIJ5Aef4
         NLiJY+jCrbYexqsByP/mD6rKfCkh9uvXB4tLYk+iuutinxix8nNqNQJkU9GPp25OL7ho
         Nz75EJhtelVZALOm1RjMn681MB9Xw20fTAgfo=
MIME-Version: 1.0
In-Reply-To: <4A1535FB.9000909@tremplin-utc.net>
References: <4A151E9F.1080405@tremplin-utc.net>
	 <4A151FFF.70406@tremplin-utc.net> <20090521104952.GB2637@elf.ucw.cz>
	 <4A1535FB.9000909@tremplin-utc.net>
Date: Thu, 21 May 2009 12:36:57 +0100
Message-ID: <36a8c4f10905210436l196214e7j72ef95bbc5ece6ef@mail.gmail.com>
Subject: Re: [PATCH 4/4] lis3: Add three new laptop models
From: Isaac702 <isaac702@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize however when I reported that I was still using the 6710
settings. When the normal axis settings were used the results showed
the 6715 should be using "y_inverted" to behave normally.
I'm sorry for reporting this incorrectly in the beginning.

On Thu, May 21, 2009 at 12:07, Éric Piel <eric.piel@tremplin-utc.net> wrote:
> Op 21-05-09 12:49, Pavel Machek schreef:
>> On Thu 2009-05-21 11:33:51, Éric Piel wrote:
>>> Separate the 6710 and 6715, and set the right axis information for the
>>> 6715.
>>> Reported-by: Isaac702 <isaac702@gmail.com>
>>>
>>> Add the 6930.
>>> Reported-by: Christian Weidle <slateroni@gmail.com>
>>>
>>> Add the 2710.
>>> Reported-by: Pavel Herrmann <morpheus.ibis@gmail.com>
>>>
>>> Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
>>
>> Acked-by: Pavel Machek <pavel@ucw.cz>
>>
>> Actually, I guess this should go before 2/4 and 3/4, as it is really
>> trivial.
> Indeed. Actually, it probably also applies cleanly on Linus' tree. So it
> could be queued for 2.6.30... but I guess it's getting too late.
>
> Eric
>
>
