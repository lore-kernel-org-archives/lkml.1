Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYHMNZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYHMNZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYHMNZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:25:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:26613 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYHMNZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=votSviVwHmDtlV1mb8UPjFWCyJBW++zkXN8MVto776f/FLsCezglaWqXJU2mbooDxl
         Ab2of43Tbf9yn8hKPWPokg5s3gqEfjxRZc6BfLkbonNi9JA3k4uUd3HVZ1KDkbAnulHX
         3gv148u4HdiK9Sx+3vqwsT0hpoNu0cJKfa4Fg=
Message-ID: <37219a840808130624p3d4dca0bja2935d6f34beaf7e@mail.gmail.com>
Date: Wed, 13 Aug 2008 09:24:58 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: reiser4 for 2.6.27-rc1
Cc: "Pavel Machek" <pavel@suse.cz>, "Tim Tassonis" <timtas@cubic.ch>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080813131839.GB26351@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4896F56D.7080503@cubic.ch> <20080813125807.GC6995@ucw.cz>
	 <20080813131839.GB26351@cs181140183.pp.htv.fi>
X-Google-Sender-Auth: 7ea12e50a64a9c54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 9:18 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, Aug 13, 2008 at 02:58:08PM +0200, Pavel Machek wrote:
>> On Mon 2008-08-04 14:26:21, Tim Tassonis wrote:
>> > >Why is reiser4 still not in a vanilla kernel for
>> > >testing. I have had
>> > >to apply the reiser4 patches from -mm kernels to
>> > >vanilla based
>> > >patchset for over a year now. Reiser4 works fine, what
>> > >will it take to
>> > >get it included in vanilla? Here is a patch to add
>> > >reiser4 to
>> > >2.6.27-rc1:
>> > >
>> > >http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch
>> > >
>> > >-Ryan
>> >
>> > A good thing for a start would be to rename the whole
>> > thing to something else, for obvious reasons.
>>
>> Whats wrong with reiser4 name?
>>
>>                                                       Pavel
>>                       (or am I feeding a troll?)
>
> Not wanting a new filesystem named after a convicted murderer is not
> a trollish suggestion.


Regardless of the murder conviction, I still believe that the guy
should get credit for his work.

Reiserfs is a name that we all know of, regardless of how current we
are with the news (although you'd have to be PRETTY far behind if you
don't know about the crime)

The current reiserfs filesystems aren't being renamed -- are they??

Does it really hurt to keep his name there?  I think it should just go as-is.

-Mike
