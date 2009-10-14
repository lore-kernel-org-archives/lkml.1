Return-Path: <linux-kernel-owner+w=401wt.eu-S934979AbZJNQ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934979AbZJNQ4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934957AbZJNQ4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:56:20 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:48409 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934955AbZJNQ4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mQAGqmBEH00XrvL37o+74HPGMZVzv+HLt4oOiv3Hi19xHc5ch7s+1eRfGrZiClkfOx
         0VvxPZ4uT18iVaQGVLPc6AeVla/Ug+s21L+CbdmnCxCeEaNFiPvEhhf0OPPpG/7UVZ+k
         AerHtjDiRghuPMt/BTp8353OyiHjDdZWZO2YE=
MIME-Version: 1.0
In-Reply-To: <200910141728.21491.bzolnier@gmail.com>
References: <4AD46380.9020308@pardus.org.tr> <200910141652.41041.bzolnier@gmail.com> 
	<20091014145605.GE2890@tuxdriver.com> <200910141728.21491.bzolnier@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 14 Oct 2009 09:55:23 -0700
Message-ID: <43e72e890910140955n295ef8d1m185592af63bc895b@mail.gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 8:28 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Wednesday 14 October 2009 16:56:05 John W. Linville wrote:
>> On Wed, Oct 14, 2009 at 04:52:40PM +0200, Bartlomiej Zolnierkiewicz wrote:
>> > On Wednesday 14 October 2009 16:09:24 John W. Linville wrote:
>> > > On Tue, Oct 13, 2009 at 11:57:57PM +0200, Bartlomiej Zolnierkiewicz wrote:
>> > >
>> > > > Several months later (after all current users are happy with the improved
>> > > > drivers) the old drivers will be removed from staging..
>> > >
>> > > I _really_ hope this isn't the standard.  By that measure, nothing
>> > > will ever leave staging as _someone_ will always have some use case
>> > > that makes the other driver better for them.
>> >
>> > Doesn't seem to be the case with all other drivers except wireless ones
>> > and the only real reason why wireless ones are so special is because of:
>> >
>> > "But then there's the users, who bitch about everything and simply do
>> > not understand what it is at stake.
>> >
>> > And all this is becoming way too messy for us to handle.
>> >
>> > Personally all I see around me is people bitching and complaining, and
>> > no code being ported."
>> >
>> > attitude which pretty much explains the problem..
>> >
>> > Please adjust the process to fix the problem yourself or if you do not
>> > want to do it just make the room for people who do.
>>
>> Alright Bartlomiej, you've had your say.  Perhaps you should go about
>> your business now.
>>
>> John
>>
>> P.S. For the record, the "But then there's the users..." quote is
>> from someone else...
>
> ..but you're still fine with its content, right?
>
> I also wonder who is really taking advantage of who here (your other mail)..
>
> You're holding users as hostages to pressure vendors to fund your projects
> and try to lure outside developers with the lovely perspective of doing
> the hardest parts of said projects.
>
> I don't have a have a problem with it personally as long as people accept
> the competition..  but instead of working on _their_ projects they go around
> screaming at everybody who does not want to spin inside the great process
> designed by them..

I hear fishing in Poland is great this time of year.

  Luis
