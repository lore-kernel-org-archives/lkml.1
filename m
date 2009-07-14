Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZGNIxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZGNIxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZGNIxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:53:31 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:38093 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZGNIxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Thslz3yhMMTv63yW5+BqJ98Dib+LO0YmJLmAxHTTEeTlDqbgbpI4YMcNwAnkollQ8W
         byIU2RCB3+vuuAb4YKoEw9aWv7ZXYi0rAtYxSErdS7ap4xtgjmv1yCFZpwy7POkgZe7Z
         50sLhTXUHjhwDJfW2NgblhUpG9JY5dz8P+KFI=
MIME-Version: 1.0
In-Reply-To: <20090714082452.GH2822@dtor-d630.eng.vmware.com>
References: <4A04E5EA.7000103@samsung.com>
	 <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com>
	 <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com>
	 <20090511031208.GA15208@dtor-d630.eng.vmware.com>
	 <5d5443650906191038o797e0c3eu8234a56ee247ea68@mail.gmail.com>
	 <5d5443650907130152t420e9426q762c24bdb1b29aae@mail.gmail.com>
	 <20090713093147.GJ10819@dtor-d630.eng.vmware.com>
	 <4A5BF6F0.6020403@samsung.com>
	 <001801ca044c$428839d0$c798ad70$%szyprowski@samsung.com>
	 <20090714082452.GH2822@dtor-d630.eng.vmware.com>
Date: Tue, 14 Jul 2009 14:23:28 +0530
Message-ID: <5d5443650907140153j7be013e0q770cf72a22715a34@mail.gmail.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
From: Trilok Soni <soni.trilok@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
       Kim Kyuwon <q1.kim@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, Jul 14, 2009 at 1:54 PM, Dmitry
Torokhov<dmitry.torokhov@gmail.com> wrote:
> On Tue, Jul 14, 2009 at 08:28:05AM +0200, Marek Szyprowski wrote:
>> Hello,
>>
>> On Tuesday, July 14, 2009 5:10 AM, Kim Kyuwon wrote:
>> > Dmitry Torokhov wrote:
>> > > On Mon, Jul 13, 2009 at 02:22:10PM +0530, Trilok Soni wrote:
>> > >> I don't see this driver picked up yet in your -next branch. We should
>> > >> target this driver to be mainlined in next merge window. This is very
>> > >> important driver for some of the embedded systems, including palm pre
>> > >> :)
>> > > I was wondering if somebody could test the patch below and if it still
>> > > works then I will apply to the next branch. Thanks!
>> > >
>> >
>> > Dear Marek,
>> >
>> > Because I don't have the NCP board(which includes the max7359 keypad)
>> > now, I can't test this patch. Marek, could you please test this patch?
>>
>> I would like to, but I could not find the base version to which I can apply
>> that patch. I've tried v2 version posted in '[PATCH] Input: add MAX7359 key
>> switch controller driver, v2' mail from Sat 2009-05-09 04:10 with 2 patches
>> posted in replies to that main, but the latest patch still fails to apply.
>>
>> Could someone send me a complete patch, so I can do a test?
>>
>
> Sending everything as attachments, maybe that will help...

I never saw/reviewed melfas touchscreen driver on linux-input ML, did
I missed something?

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
