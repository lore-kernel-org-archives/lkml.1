Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZIUSS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZIUSS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZIUSSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:18:25 -0400
Received: from khc.piap.pl ([195.187.100.11]:56073 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbZIUSSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:18:25 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: [PULL REQ] IXP4xx
Date: Mon, 21 Sep 2009 20:18:26 +0200
Message-ID: <m3eiq0duvh.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from my IXP4xx tree. This is rather trivial, and based on
your current HEAD to eliminate a conflict. Thanks.

The following changes since commit 43c1266ce4dc06bfd236cec31e11e9ecd69c0bef:
  Linus Torvalds (1):
        Merge branch 'perfcounters-rename-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git ixp4xx

Krzysztof Hałasa (1):
      Add MAINTAINERS entry for ARM/INTEL IXP4xx arch support.

Mikael Pettersson (2):
      ixp4xx: timer and clocks cleanups
      ixp4xx: arch_idle() documentation fixup

 MAINTAINERS                                |    7 +++++++
 arch/arm/mach-ixp4xx/common.c              |   16 +++++++---------
 arch/arm/mach-ixp4xx/include/mach/system.h |    6 ++++--
 3 files changed, 18 insertions(+), 11 deletions(-)

-- 
Krzysztof Halasa
