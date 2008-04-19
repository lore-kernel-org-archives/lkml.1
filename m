Return-Path: <linux-kernel-owner+w=401wt.eu-S1762099AbYDSOxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099AbYDSOxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761828AbYDSOxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:53:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:42417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761802AbYDSOx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:53:29 -0400
Date: Sat, 19 Apr 2008 14:53:27 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36.3
Message-ID: <20080419145327.GA23566@hera.kernel.org>
Reply-To: w@1wt.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I've just released Linux 2.4.36.3.

Nothing outstanding here, I've just decided to release pending fixes.
Those already running 2.4.36.2 have no particular reason to upgrade,
unless they already experience troubles in the fixed areas.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.3.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.3

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.36.y.git

Regards,
Willy
--

Summary of changes from v2.4.36.2 to v2.4.36.3
============================================

David Newall (1):
      usb-serial: back-port of pl2303.c from 2.6.24.1

Glen Nakamura (3):
      ext2_readdir() filp->f_pos fix (try #2)
      Duplicate id in videodev.h
      Fix typo in acpi_boot_init

Jesse Brandeburg (1):
      ip-pnp-dhcp: wait lazily when doing dhcp for diskless systems

Patrick McHardy (1):
      [TCP]: Fix shrinking windows with window scaling

Willy Tarreau (2):
      intermezzo: fix uninitialized use of pointer in error path
      Change VERSION to 2.4.36.3


