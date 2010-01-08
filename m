Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261Ab0AHCLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0AHCLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 21:11:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130Ab0AHCLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 21:11:05 -0500
Received: from trinity.fluff.org ([89.16.178.74]:56203 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab0AHCLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 21:11:04 -0500
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-samsung-soc@vger.kernel.org, torvalds@linux-foundation.org
Subject: Please pull bjdooks' for-linus/samsung
From: Ben Dooks <ben-linux@fluff.org>
Message-Id: <E1NT4JR-0006WN-6J@trinity.fluff.org>
Date: Fri, 08 Jan 2010 02:10:53 +0000
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c5974b835a909ff15c3b7e6cf6789b5eb919f419:
  Linus Torvalds (1):
        Merge branch 'limits_cleanup' of git://decibel.fi.muni.cz/~xslaby/linux

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-linus/samsung

Ben Dooks (1):
      ARM: S3C64XX: Fix possible clock look in EPLL and MPLL clock chains

 arch/arm/plat-s3c64xx/s3c6400-clock.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)
