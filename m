Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYJVS3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYJVS3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYJVS33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:29:29 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:16605 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbYJVS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:29:28 -0400
X-RZG-CLASS-ID: mo05
X-RZG-AUTH: :Pm0FVUW6aauhRGJJc5OfA4AU8DM8ZlijdmJYxKn/UQvEQQx8AU81rZ3v
Date: Wed, 22 Oct 2008 20:29:24 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx@mcentral.de
Subject: Re: [PATCH] em28xx patches against the latest git tree
Message-ID: <20081022182924.GA4626@blimp.localdomain>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com> <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com> <81b0412b0810221059w2e02b1c1ubd894b22f7991242@mail.gmail.com> <d9def9db0810221110g6f104b17g36a74704d43c5693@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0810221110g6f104b17g36a74704d43c5693@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger, Wed, Oct 22, 2008 20:10:49 +0200:
> On Wed, Oct 22, 2008 at 7:59 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
> > 2008/10/22 Markus Rechberger <mrechberger@gmail.com>:
> >>> commit history is available at:
> >> http://mcentral.de/hg/~mrec/em28xx-new/shortlog
> >>
> >
> > There is already an Empia EM28XX driver in the official tree. If your driver
> > is based on it, could you point at the first commit in *your* tree at
> > mcentral.de which
> > corresponds to that driver? (if you do, your history can be moved into
> > central Git
> > repo completely, every commit of it)
> >
> 
> The development has been split off for 3 years from the original
> repository. The internal driver differs alot.

So it is more like a new driver. I tried merging them about half a
year ago (unsuccessfully, of course). In the end your driver worked
with that piece of hardware I have (it seem to produce an awful lot of
tracing though) and I stayed with it.

> The driver has a long and rather bad history, which I'd like to avoid
> by using the different directory.

You could submit patches depricating it. Does the old driver support
something yours does not?

> Some patches got ported from my repository into the kernel although
> most devices don't work at all with the current inkernel driver (eg.
> em2888, flash based, isdb-t, cx25843, some saa7114.. based devices).

Mine (a Pinnacle-Apple-something, USB) does not work with it at all.

