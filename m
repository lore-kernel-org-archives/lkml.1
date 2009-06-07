Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZFGXmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZFGXmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 19:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZFGXmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 19:42:06 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44185 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZFGXmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 19:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=e/u0y4xUsyKpcIBIH5loZxWcDGVK/EMSqtpm6Bs10s0gXCkOpsfRYkUQ3kU4EutIS0
         0KdPRjszyjntRTvupsVUXrA2xarq4wYaL5wSahsbS2KgwjvgYb1hokShkK6FIfPLWotY
         /Hcm5ZPI4sHurPEPjf08Jp6WR3gxKtksNvorU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] IDE fixes
Date: Mon, 8 Jun 2009 01:47:11 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <200906072125.40784.bzolnier@gmail.com> <alpine.LFD.2.01.0906071614560.6847@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906071614560.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906080147.12274.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009 01:15:42 Linus Torvalds wrote:
> 
> On Sun, 7 Jun 2009, Bartlomiej Zolnierkiewicz wrote:
> > 
> > To be perfectly clear on this:
> > 
> > * all patches were posted a week ago to the list (they replaced patches
> >   from two weeks ago -- which were intended for -rc8 but thanks to feedback
> >   I found a better way to do it).
> 
> Bartlomiej - if you want to add new features, they should have been posted 
> on the list BEFORE THE MERGE WINDOW EVEN OPENED.

This is not a new feature and basing your opinions on opinions of people
who don't read the code before commenting is bad, really bad, m'kay?

Anyway I'll revisit the pull request tomorrow.
