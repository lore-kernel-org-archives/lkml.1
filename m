Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZLPQ5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZLPQ5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZLPQ5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:57:40 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:34941
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751908AbZLPQ5j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:57:39 -0500
X-SpamScore: 7
X-BigFish: VPS7(z37d4lzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUR8FO-02-C19-02
X-M-MSG: 
Date: Wed, 16 Dec 2009 17:57:38 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Doug Thompson <norsk5@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac: two small fixlets for .33
Message-ID: <20091216165738.GG11618@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Dec 2009 16:57:25.0656 (UTC) FILETIME=[D7DDE180:01CA7E70]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull two small fixlets for amd64_edac.

Thanks.

The following changes since commit 8bea8672edfca7ec5f661cafb218f1205863b343:
  Stephen Rothwell (1):
        mfd: compile fix for twl4030 renaming

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (2):
      edac, mce: correct corenum reporting
      edac, mce, amd: silence GART TLB errors

 drivers/edac/edac_mce_amd.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

