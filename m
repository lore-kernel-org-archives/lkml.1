Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZG0My5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZG0My5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 08:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZG0My4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 08:54:56 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:35657 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbZG0Myz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 08:54:55 -0400
X-SpamScore: -11
X-BigFish: VPS-11(z21eWzzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNFYIR-04-EQO-01
Date: Mon, 27 Jul 2009 14:54:30 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD64 EDAC fix for 2.6.31-rc5
Message-ID: <20090727125430.GC28229@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 27 Jul 2009 12:54:28.0400 (UTC) FILETIME=[607CA300:01CA0EB9]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following AMD64 EDAC fix.

The following changes since commit 4be3bd7849165e7efa6b0b35a23d6a3598d97465:
  Linus Torvalds (1):
        Linux 2.6.31-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Wan Wei (1):
      amd64_edac: read the right F2 maskoffset reg

 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

