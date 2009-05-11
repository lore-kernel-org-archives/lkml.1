Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZEKCf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZEKCf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZEKCfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:35:17 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:36005 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZEKCfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Kc+0RFyLnDTrAXmjRsqa/126YMAAF2jG9uF8+f4cCQZI2wYxevf2lKCcpX8J/09ruY
         /lvLdpHgiJjoD+nCsPzyo+uHFII5HZEe+7foGWhQb24Zcyqou/F4YbtvzluYIh8jNF8p
         0QaYAjWQCXIURC1revTqQuT+Mx9Jt6i8R3zos=
MIME-Version: 1.0
In-Reply-To: <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com>
References: <4A04E5EA.7000103@samsung.com> <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com>
From: Kim Kyuwon <chammoru@gmail.com>
Date: Mon, 11 May 2009 11:34:54 +0900
Message-ID: <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trilok,

On Sun, May 10, 2009 at 2:27 AM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Kim,
>
> On Sat, May 9, 2009 at 7:39 AM, Kim Kyuwon <q1.kim@samsung.com> wrote:
>> The Maxim MAX7359 is a I2C interfaced key switch controller which provides
>> microprocessors with management of up to 64 key switches.
>> This patch adds support for the MAX7359 key switch controller.
>>
>> Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
>
>
> Thanks for implementing review comments. Please add
>
> Reviewed-by: Trilok Soni <soni.trilok@gmail.com>

Sorry, I didn't know I should put the "Reviewed-by" in the reviewed
patch.(I'm still kernelnewbie :) ) If possible, I want Dmitry to add
"Reviewed-by" when he sends this driver to mainline, or I will send
new patch again.

Thanks again for you reviewing.

Kyuwon (±Ô¿ø)
