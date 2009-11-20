Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZKTUJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZKTUJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZKTUJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:09:06 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51166 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbZKTUJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:09:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xAZ5CzH2DsGQYKkZEGWdm79LW9SbfNlZJUo8tEAqRD1K/Tkfd283sXsG7DAmhxDdv5
         4jgtrRsGsz0/DUEDRUgU6LAFlTyF/PY9LbAk/xcxMgph43qV5Win704Bhss+I7zQ5TCg
         MrrPk2SOrssKT0+Qsov1Bsxj1F/PpRROvZhZk=
MIME-Version: 1.0
In-Reply-To: <20091120192250.GA16773@kroah.com>
References: <1256861066-21954-1-git-send-email-tfransosi@gmail.com>
	 <20091106224728.GA32205@kroah.com>
	 <a4c8a6d00911061547x3d502de5i8a459385e1a5a9ff@mail.gmail.com>
	 <20091107000749.GA26070@kroah.com>
	 <a4c8a6d00911061723v6017ad7bqf96ba7c905922a45@mail.gmail.com>
	 <a4c8a6d00911061745s4508d997v684683a1dbad821d@mail.gmail.com>
	 <20091119193447.GA29091@kroah.com>
	 <a4c8a6d00911201118n7607b0f8nf56f7af1e071afb6@mail.gmail.com>
	 <20091120192250.GA16773@kroah.com>
Date: Fri, 20 Nov 2009 18:09:09 -0200
Message-ID: <a4c8a6d00911201209p2da69bb5s50b6d098107842db@mail.gmail.com>
Subject: Re: [PATCH v2] staging/otus: trivial, fix sparse warnig.
From: Thiago Farina <tfransosi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 5:22 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 20, 2009 at 05:18:09PM -0200, Thiago Farina wrote:
>> Hi Greg,
>>
>> On Thu, Nov 19, 2009 at 5:34 PM, Greg KH <greg@kroah.com> wrote:
>> > On Fri, Nov 06, 2009 at 11:45:05PM -0200, Thiago Farina wrote:
>> >> *apdbg.c: use NULL pointer instead of 0 integer.
>> >>
>> >> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
>> >
>> > Still doesn't apply, I don't know what you are doing wrong here :(
>> >
>> > odd.
>>
>> How are you applying it?
>
> 'patch -p1 < your_email'

Are you getting something like: "Hmm... Ignoring the trailing garbage." ?

The output for me was this:
...
Patching file drivers/staging/otus/apdbg.c using Plan A...
Hunk #1 succeeded at 109.
Hunk #2 succeeded at 123.
Hmm...  Ignoring the trailing garbage.
done
