Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYHMQay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYHMQay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYHMQaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:30:46 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:2932 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYHMQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:30:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T4YPbzBlMtKxrNuw6XzU7CN2rnaJQYbW5nuiX6KyVz9F1LQ5WAVZmfXZU1cAQDNQvq
         fyT9gRKGc/bROKojyTGBXvvkREgvQde27GohV70J/LDe3bypG0/c0RygklZ7UeVg/dIz
         1Sb63usxZYWgmm3La294l9p4gr1gDKcSuuj5U=
Message-ID: <48f7fe350808130930g1bd07dfek74195e68d9299482@mail.gmail.com>
Date: Wed, 13 Aug 2008 12:30:44 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: timtas@cubic.ch
Subject: Re: reiser4 for 2.6.27-rc1
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Michael Krufky" <mkrufky@linuxtv.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Pavel Machek" <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48A2FCA2.4040603@cubic.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4896F56D.7080503@cubic.ch> <20080813125807.GC6995@ucw.cz>
	 <20080813131839.GB26351@cs181140183.pp.htv.fi>
	 <37219a840808130624p3d4dca0bja2935d6f34beaf7e@mail.gmail.com>
	 <48A2E391.3080404@cubic.ch>
	 <20080813143613.61101a5e@lxorguk.ukuu.org.uk>
	 <48A2E8EA.2060704@cubic.ch>
	 <48f7fe350808130759w18b887dcr1978ccf1c49d1c75@mail.gmail.com>
	 <48A2FCA2.4040603@cubic.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the name of a filesystem should have no bearing on whether or not
people want to include it in mainline, people should not use its name
as an argument against including it

On Wed, Aug 13, 2008 at 11:24 AM, Tim Tassonis <timtas@cubic.ch> wrote:
> Ryan Hope wrote:
>>
>> On Wed, Aug 13, 2008 at 10:00 AM, Tim Tassonis <timtas@cubic.ch> wrote:
>>>
>>> I am in favour of renaming reiser4 exactly because it is not yet in and
>>> naming a filesystem after its author is not as automatic as putting the
>>> name
>>> of the singer on a record sleeve.
>>
>> There is no point in renaming the filesystem, its already known as
>> reiser4, it should stay that way.
>
> One last (batch of) comment(s):
>
> I am not advocating renaming the existing -mm implementation to something
> else so it can rot there under a different name.
>
> I can very well live with reiser4 not making it into mainline, I never used
> reiser3 (only once for two, and after a power outage rendered the fs
> unusable and fsck did fsck all, I chose reliability over "performance") and
> am quite happy with ext3 for years and btrfs looks promising, too.
>
> I was merely thinking: If reiser4 really is all that great and some people
> want it desperately in mainline, apart from fixing outstanding issues or
> convincing Al etc there are none left, they might rename it to reduce the
> controversy potential over its inclusion. I would think that for people
> desperately wanting it in, the features of reiser4 are more important than
> the name and the name is probably somewhat "difficult".
>
> Renaming something for political reasons is certainly something you
> shouldn't do aggressively, but I would favour it in this case:
> - For mainline, it's no rename, as it is not in yet.
> - I don't like having the author's name as the fs's name anyway.
> - It might save some unnecessary bad press .
>
> On the other hand, I guess the real victims probably don't care and so it
> wouldn't bother me that much either.
>
> Tim
>
>
