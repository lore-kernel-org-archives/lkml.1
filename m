Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbZCNOTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbZCNOTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 10:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZCNOT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 10:19:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43573 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752858AbZCNOTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 10:19:25 -0400
Date: Sat, 14 Mar 2009 14:19:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 12 (tty)
Message-ID: <20090314141959.418ea04c@lxorguk.ukuu.org.uk>
In-Reply-To: <200903141411.50185.bzolnier@gmail.com>
References: <20090312171154.11c6ec31.sfr@canb.auug.org.au>
	<200903141411.50185.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009 14:11:49 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> 
> Hi,
> 
> On Thursday 12 March 2009, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090311:
> 
> It fails to boot here (both with QEMU and the real hardware):
> 
> ...
> Warning: unable to open an initial console.
> Kernel panic - not syncing: Attempted to kill init!
> ...
> 
> I bisected the problem to:
> 
> From 31f8326f981117fc548d292656fa8dbed28bc42b Mon Sep 17 00:00:00 2001
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Thu, 12 Mar 2009 10:00:15 +110

GAK thanks - I'll sort that mess out monday.
