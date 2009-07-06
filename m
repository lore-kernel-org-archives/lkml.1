Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZGFVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZGFVcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZGFVcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:32:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57239 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZGFVcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:32:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: michal.simek@petalogix.com
Subject: Re: linux-next: manual merge of the suspend tree with the microblaze tree
Date: Mon, 6 Jul 2009 23:32:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Linn <john.linn@xilinx.com>,
       Magnus Damm <damm@igel.co.jp>
References: <20090706140050.0dec74a2.sfr@canb.auug.org.au> <4A51A5E9.1030605@petalogix.com>
In-Reply-To: <4A51A5E9.1030605@petalogix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907062332.24018.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009, Michal Simek wrote:
> Stephen Rothwell wrote:
> > Hi Rafael,
> >
> > Today's linux-next merge of the suspend tree got a conflict in
> > arch/microblaze/include/asm/device.h between commit
> > 19aff4132a289ec83ca6eee8b3db28855b9f06af ("microblaze: Adding
> > dev_arch_data functions") from the microblaze tree and commit
> > c959b4101b10723eeb190ef2e82765dd529c26b6 ("Driver Core: Add platform
> > device arch data V3") from the suspend tree.
> >
> > Just overlapping additions.  I fixed it up (see below) and can carry the
> > fix as necessary.
> >   
> I'll revert this patch and I'll add it later.
> Rafael you don't need to do any changes. I'll do them.
> This John L patch is not important - just for any drivers which are not
> in mainline.
> I'll add it later.

Many thanks!

Best,
Rafael
