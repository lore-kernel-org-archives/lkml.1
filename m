Return-Path: <linux-kernel-owner+w=401wt.eu-S1763195AbZFNUrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763195AbZFNUrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbZFNUro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:47:44 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:37538 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbZFNUrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:47:43 -0400
Date: Sun, 14 Jun 2009 22:50:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Floris Kraak <randakar@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
Message-ID: <20090614205002.GE3187@uranus.ravnborg.org>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com> <84144f020905150323m76cdd775p87abec356e355d37@mail.gmail.com> <56e1b5710905150628w912759an21c82efc3fae7f4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56e1b5710905150628w912759an21c82efc3fae7f4a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 03:28:18PM +0200, Floris Kraak wrote:
> On 5/15/09, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >
> > On Wed, Feb 4, 2009 at 5:28 PM, Floris Kraak <randakar@gmail.com> wrote:
> > > Some distributions have enabled the gcc flag -Wformat-security by default.*
> > > This results in a number of warnings about format arguments to
> > > functions, sometimes in cases where fixing the warning is not likely
> > > to actually fix a bug.
> > > Instead of hand patching a dozens of places (possibly more) that
> > > produce warnings that get ignored anyway we just turn off the flag in
> > > the Makefile.
> > >
> >
> > Is there a reason this patch was not merged? Yes, it's clearly a
> > distro problem but apparently there's no easy way to turn it off.
> >

I have lost the original patch to disable this check.
Could you please resend.

Thanks,
	Sam
