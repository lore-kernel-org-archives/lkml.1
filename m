Return-Path: <linux-kernel-owner+w=401wt.eu-S1763437AbXF0WB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763437AbXF0WB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbXF0WBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:01:50 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54530 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816AbXF0WBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:01:50 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, josh@kernel.org
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
In-Reply-To: <20070627123122.257661e3.akpm@linux-foundation.org>
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com> <20070627123122.257661e3.akpm@linux-foundation.org>
Date: Thu, 28 Jun 2007 00:14:38 +0200
Message-Id: <E1I3fmY-0003A8-8D@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Newsgroups: gmane.linux.kernel
> Date: Wed, 27 Jun 2007 12:31:22 -0700

><checks>
>
> akpm:/usr/src/25> grep -l "^+.*[        ]$" patches/git-*.patch
> patches/git-acpi.patch
> patches/git-alsa.patch
> patches/git-battery.patch
> patches/git-cifs.patch
> patches/git-drm.patch
> patches/git-gfs2-nmw.patch
> patches/git-hid.patch
> patches/git-ipwireless_cs.patch
> patches/git-ixgbe.patch
> patches/git-kgdb.patch
> patches/git-leds.patch
> patches/git-libata-all.patch
> patches/git-md-accel.patch
> patches/git-netdev-all.patch
> patches/git-newsetup.patch
> patches/git-nfs.patch
> patches/git-ocfs2.patch
> patches/git-pciseg.patch
> patches/git-qla3xxx.patch
> patches/git-selinux.patch
> patches/git-sym2.patch
> patches/git-unionfs.patch
> patches/git-watchdog.patch
> patches/git-wireless.patch
>
> damn.  Bunch of lamers.

    9. The editor is the primary tool for programmers. People who don't
       choose an appropriate primary tool are worthless as professionals.

among others in <http://quimby.gnus.org/circus/notes/programming.html>

I've shared little sh script too, 4 + 2(optional) sed commands with
comments of what whitespace crap was spotted. Yet nothing happened.
Converse -- questions about why they are useless...

Introduction of editor's labels in C files is the most outrages thing.
Don't editors smart to see filename extensions first? If they don't, fix
editors, not sources!

> But there's less than there used to be.
____
