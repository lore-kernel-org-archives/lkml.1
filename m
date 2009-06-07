Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbZFGTK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbZFGTK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 15:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZFGTJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 15:09:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:36348 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbZFGTJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 15:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rleWSwZ0InDdWAFAMEWtxC9jYhlH1pFYRo1FwICy0XVMUFVf1vxZ1OIN/y9sI4IZMm
         Qek8XdjjIBlp3bY9Rb9FT2LVRFXmaYsema2BH3lMHOx0stvyaLIrBZC7+ltKpjsGeMCr
         YGTbBlsSiGtQSnytzdzztK8+U6pAorRkqu0wI=
MIME-Version: 1.0
In-Reply-To: <200906072100.10649.bzolnier@gmail.com>
References: <200906071444.33047.bzolnier@gmail.com>
	 <200906071955.42378.bzolnier@gmail.com>
	 <84144f020906071121k34d6d555i6332d49b0db0fac6@mail.gmail.com>
	 <200906072100.10649.bzolnier@gmail.com>
Date: Sun, 7 Jun 2009 22:09:47 +0300
X-Google-Sender-Auth: f219810e50430a5e
Message-ID: <84144f020906071209m51e5fd15jaa67f9143ab1d126@mail.gmail.com>
Subject: Re: [git pull] IDE fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On Sun, Jun 7, 2009 at 10:00 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>> > My honest opinion is that it is as appropriate now as it will be 2.6.31.
>> >
>> > [ I'm still amazed by the amount of *completely* bogus reasons given for
>> >  not merging it. ]
>>
>> I don't consider this a bogus reason at all:
>>
>>  10 files changed, 134 insertions(+), 43 deletions(-)
>
> Since when do we validate code quality based solely on LOC changed? :)

Since when we entered -rc8 (or even earlier).

On Sun, Jun 7, 2009 at 10:00 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> I'm yet to see anybody posting a single code chunk in this whole discussion.

That's because I am not objecting to the code. I am objecting to the
fact that you're submitting something as big as this so late in the
release cycle and the fact that it's not a clear-cut bug fix.

But anyway, I don't really want to argue about this. I simply wanted
to point out that I agree with Alan's and James' comments and that I
don't think they have anything to do with "slowing down IDE fixes" but
rather with how the whole release cycle with fixed merge window works.

                        Pekka
