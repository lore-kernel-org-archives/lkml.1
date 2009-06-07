Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZFGRw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZFGRw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 13:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbZFGRv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 13:51:58 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41029 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZFGRvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 13:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LpD1m/bqQLuFuR1ZUJIuYEYqWoLxGvGocT4Zi10vhEuCHuauzlfHLpKPkFENLtPy8O
         VEe19NljGn4gVqUr8xr7hbRSfqnUDJcRc5W2Y7urRFg0E7z+fN6BGnTKAjST9/3dKqae
         Ax4wpalqRZ49bOVOYQSzvVocyYcgQ73qc0ibE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 19:55:42 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <200906071744.23629.bzolnier@gmail.com> <84144f020906070954p54cdfee4y62a51795be10b0d0@mail.gmail.com>
In-Reply-To: <84144f020906070954p54cdfee4y62a51795be10b0d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906071955.42378.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 18:54:08 Pekka Enberg wrote:
> Hi Bartlomiej,
> 
> On Sun, Jun 7, 2009 at 6:44 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > Honestly, this should be solved on technical basis by somebody posting
> > needed libata patches instead of attempts to slow down IDE fixes.
> 
> Nobody is "slowing down" IDE fixes here. Linus explicitly said that
> -rc8 is the last release candidate and the next one is going to be
> -final. There's absolutely _no way_ this series is appropriate at the
> very end of a release cycle.

My honest opinion is that it is as appropriate now as it will be 2.6.31.

[ I'm still amazed by the amount of *completely* bogus reasons given for
  not merging it. ]

However it sure can wait, no big deal (though I still think that it was
worth to try to get it in and not make users wait another few months).

I'll let Linus decide and revise pull request if necessary.
