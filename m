Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbZDWMVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbZDWMVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZDWMVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:21:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:8635 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZDWMVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:21:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding:reply-to;
        b=S0zh2MXzLmxAhVRN75zZZu+5rwHC5tApIII2HmTtp1ZPk7pO5PuA+fde1Hp9XMAlAZ
         z8Yog093rwEf4EPYPRnpLmUmAbgN6cXfXYoMXiINfzqNpEWvJsQ6q6HKoUQR0XUxQmpG
         iTgYcZQpKqeqgYSx+1Kawt568ILLkNIKf5yMU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ray Lee <ray-lk@madrabbit.org>
Subject: Re: [git pull] IDE fixes
Date: Thu, 23 Apr 2009 00:51:24 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Joe Perches <joe@perches.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200904222048.15556.bzolnier@gmail.com> <200904222341.37846.bzolnier@gmail.com> <2c0942db0904221502x266b66far303102c019e5e0cb@mail.gmail.com>
In-Reply-To: <2c0942db0904221502x266b66far303102c019e5e0cb@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904230051.24622.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009 00:02:38 Ray Lee wrote:
> On Wed, Apr 22, 2009 at 2:41 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > On Wednesday 22 April 2009 21:55:03 Joe Perches wrote:
> >> On Wed, 2009-04-22 at 21:43 +0200, Bartlomiej Zolnierkiewicz wrote:
> >> > IMO we should just remove extra commas and add some whitespaces.
> >>
> >> Your choice.
> >> Ignore, reject, accept, improve, fine by me.
> >>
> >> > I have also more general (process oriented) comment:
> >> >
> >> > All patches have been posted to linux-kernel or linux-ide for review before
> >> > and it is _much_ more efficient to raise issues (including CodingStyle ones)
> >> > during "review phase" instead of during "push to Linus" phase.
> >>
> >> Maybe for you, but I'm an intermittent
> >> and random reader.
> >
> > For everybody involved in the process -- this includes you.
> >
> > I'm not the original author of many patches so I simply cannot be
> > correcting every single issue because:
> >
> > a) it is physically impossible
> >
> > b) it doesn't really educate people
> 
> His point is that you can queue a follow-up patch to remove the
> ugliness. Just because it didn't get caught until the push stage
> doesn't mean the code needs to stay set in stone for the rest of
> eternity.

I get his point and of course patches are welcomed.

However my point is that it is still suboptimal way to address
the issue in the long-term and from my perspective the long-term
is what really matters.

Thanks,
Bart
