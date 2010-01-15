Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0AOIK6 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 03:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122Ab0AOIKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 03:10:55 -0500
Received: from trinity.fluff.org ([89.16.178.74]:60772 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab0AOIKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 03:10:53 -0500
Date: Fri, 15 Jan 2010 08:10:45 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>
Subject: [PULL] Please pull bjdooks' for-linus/samsung branch
Message-ID: <20100115081045.GA13888@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 004b35063296b6772fa72404a35b498f1e71e87e:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-linus/samsung

Ben Dooks (1):
      ARM: MINI2440: Fixup __initdata usage

Mark Brown (1):
      ARM: SMDK6410: Specify no GPIO for B_PWR_5V regulator

Ramax Lo (1):
      ARM: S3C: NAND: Check the existence of nr_map before copying

Uri Yosef (1):
      ARM: MINI2440: Fix crash on boot due to improper __initdata qualifier

 arch/arm/mach-s3c2440/mach-mini2440.c |   36 ++++++++++++++++----------------
 arch/arm/mach-s3c6410/mach-smdk6410.c |    1 +
 arch/arm/plat-s3c/dev-nand.c          |    4 +-
 3 files changed, 21 insertions(+), 20 deletions(-)

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.
