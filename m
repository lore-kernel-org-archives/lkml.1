Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZGUTgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZGUTgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbZGUTgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:36:50 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:27436 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbZGUTgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=EyVVNRiQwSczDc4C5Wm779fqx20Ik9OgPEvKnp+1R0CxjXRnbIxtI/flflpkI1K5A7
         PJwJtfZ0Y7Lq4nTcvMD6RQiTL3gAkUg4ExQYgJCXpSz3CMJcZz8HUGCoEOH6oBGOg8zP
         Wayrs4z8FlApu/8SV/WhLbatqfS5dQU8+Xxyg=
MIME-Version: 1.0
Reply-To: john.lanza@linux.com
In-Reply-To: <4bbed3f70907210808m2c90ee4frd3470c1a1310758b@mail.gmail.com>
References: <19028.3736.892828.352905@samba.org>
	 <1247069202.4159.212.camel@mulgrave.site>
	 <20090708171848.21633768@lxorguk.ukuu.org.uk>
	 <873a96a23x.fsf@devron.myhome.or.jp>
	 <87hbxhwv0j.fsf@devron.myhome.or.jp>
	 <19045.14307.658887.752950@samba.org> <4A65875D.7030902@panasas.com>
	 <20090721103158.GG4133@elf.ucw.cz>
	 <19045.49553.738185.211806@samba.org>
	 <4bbed3f70907210808m2c90ee4frd3470c1a1310758b@mail.gmail.com>
Date: Tue, 21 Jul 2009 15:36:49 -0400
Message-ID: <4bbed3f70907211236k736bc43ase3ed1c90f8ee92d8@mail.gmail.com>
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
From: John Lanza <jdlanza@gmail.com>
To: tridge@samba.org
Cc: Pavel Machek <pavel@ucw.cz>, Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending in plain text..........

On Tue, Jul 21, 2009 at 11:08 AM, John Lanza <jdlanza@gmail.com> wrote:
>
> All:
>
> I think the email I just sent applies here, as well.  And I echo
> Tridge's sentiments about giving me a shout if you have some idea for
> qorkarounds.  I'm here to be a sounding board for you.
>
> johnl
>
> On Tue, Jul 21, 2009 at 9:24 AM, <tridge@samba.org> wrote:
> > Hi Pavel,
> >
> >  > Actually, why not having dosfsck creating _matching_ short names for
> >  > long names? As it only writes short names, it should be safe :-).
> >
> > As I mentioned to Boaz, what usually matters for claim construction in
> > patents is the overall system. I'm sure John Lanza would be happy to
> > run through it with you if you want a more legally detailed answer,
> > but basically breaking it up within the one system isn't likely to
> > help us.
> >
> > Like I mentioned to Boaz though, do keep thinking about it. There may
> > well be a better solution that nobody has suggested yet. You might
> > also like to read the file wrapper (availble on the USPTO site) which
> > shows the discussions between the patent office and the
> > applicant. That is often a good source of inspiration for patent
> > workarounds. If you think you've found something then it might be a
> > good idea to raise it with John Lanza first.
> >
> > Cheers, Tridge
> >
