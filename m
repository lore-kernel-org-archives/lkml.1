Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZDVWDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZDVWDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZDVWC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:02:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:14056 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZDVWCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=I9Arx7Oh/ZjbxmqtWIFoEbecEHeDmvNf2uVzrqMI6fauAOOKYmhHRQAj8oYQkvu9sZ
         Yd21UYU/F+BjrsDAr+a8T5+oXclRMzI19yc6uFkxOq1NScUSz8V1Z7zWMRWdr+KAaCx3
         6YHDeCYZkubxqygqHt31LQkowBYevwf2yX92Q=
MIME-Version: 1.0
In-Reply-To: <200904222341.37846.bzolnier@gmail.com>
References: <200904222048.15556.bzolnier@gmail.com> <200904222143.47220.bzolnier@gmail.com> 
	<1240430103.21848.101.camel@localhost> <200904222341.37846.bzolnier@gmail.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Wed, 22 Apr 2009 15:02:38 -0700
X-Google-Sender-Auth: 691f50b0dc386084
Message-ID: <2c0942db0904221502x266b66far303102c019e5e0cb@mail.gmail.com>
Subject: Re: [git pull] IDE fixes
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Joe Perches <joe@perches.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 2:41 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Wednesday 22 April 2009 21:55:03 Joe Perches wrote:
>> On Wed, 2009-04-22 at 21:43 +0200, Bartlomiej Zolnierkiewicz wrote:
>> > IMO we should just remove extra commas and add some whitespaces.
>>
>> Your choice.
>> Ignore, reject, accept, improve, fine by me.
>>
>> > I have also more general (process oriented) comment:
>> >
>> > All patches have been posted to linux-kernel or linux-ide for review before
>> > and it is _much_ more efficient to raise issues (including CodingStyle ones)
>> > during "review phase" instead of during "push to Linus" phase.
>>
>> Maybe for you, but I'm an intermittent
>> and random reader.
>
> For everybody involved in the process -- this includes you.
>
> I'm not the original author of many patches so I simply cannot be
> correcting every single issue because:
>
> a) it is physically impossible
>
> b) it doesn't really educate people

His point is that you can queue a follow-up patch to remove the
ugliness. Just because it didn't get caught until the push stage
doesn't mean the code needs to stay set in stone for the rest of
eternity.

What most maintainers do at this stage is say "Great idea! Send me a
patch." Perhaps you could try that tack instead.
