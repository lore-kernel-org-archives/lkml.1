Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZETQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZETQTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZETQTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:19:18 -0400
Received: from svenhartge.de ([81.169.140.245]:58094 "EHLO svenhartge.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZETQTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:19:17 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 12:19:17 EDT
Path: ds9.feds.ath.cx!oweh
From: Sven Hartge <sven@svenhartge.de>
Subject: Re: Linux 2.6.29.4
To: linux-kernel@vger.kernel.org
References: <20090520053031.GC13453@kroah.com> <5ab239b10905200806h78e2649cy1aa7408fd6653262@mail.gmail.com>
User-Agent: tin/1.9.4-20090211 ("Rieclachan") (UNIX) (Linux/2.6.28.7-216 (i686))
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Message-Id: <E1M6oN5-0003S3-Gk@mids.svenhartge.de>
Date: Wed, 20 May 2009 18:10:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"D. Kelly" <user.kernel@gmail.com> wrote:
> Hi.  I have just updated my kernel from:

> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.4.tar.bz2

> However, I am getting some errors after I `make menuconfig`:

> exec make kpkg_version=12.013 -f
> /usr/share/kernel-package/ruleset/minimal.mk debian
> DEBIAN_REVISION=Build.1  APPEND_TO_VERSION=.amd64-x2.052009.1
> tail: cannot open `debian/changelog' for reading: No such file or directory
> dpkg-parsechangelog: failure: tail of debian/changelog gave error exit status 1

Those are harmless messages, which are to be expected when using a
kernel-package version from Debian Sid. The kernel will be build fine
and correct.

Grüße,
S°

-- 
Sig lost. Core dumped.
