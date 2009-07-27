Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZG0VdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZG0VdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZG0VdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:33:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33693 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754518AbZG0VdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:33:17 -0400
Date: Mon, 27 Jul 2009 22:34:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 27 (tty locking)
Message-ID: <20090727223415.5e79159c@lxorguk.ukuu.org.uk>
In-Reply-To: <200907272235.08319.bzolnier@gmail.com>
References: <20090727180552.eb32515b.sfr@canb.auug.org.au>
	<200907272235.08319.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 22:35:08 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> 
> Hi,
> 
> On Monday 27 July 2009 10:05:52 Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090724:
> 
> Alan, it seems that tty still needs some polishing,
> I'm getting the following warning on boot:

Oh the -next tty patches need quite a bit of polishing yet. I've been
flat out dealing with fallout from the current kernel though so haven't
got time to deal with -next bugs just yet.

I know which diff that is however so I'll drop it out and push a new
-next tree.
