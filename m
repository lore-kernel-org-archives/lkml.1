Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZFZLVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZFZLVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 07:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZFZLVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 07:21:42 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:20988 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbZFZLVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 07:21:41 -0400
X-SpamScore: 4
X-BigFish: VPS4(zzzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KLUFJU-01-MSD-01
Date: Fri, 26 Jun 2009 13:21:31 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD64 EDAC fixes
Message-ID: <20090626112131.GA1265@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 26 Jun 2009 11:21:32.0511 (UTC) FILETIME=[42313EF0:01C9F650]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following amd64 EDAC fixlets.

Thanks.

The following changes since commit 28d0325ce6e0a52f53d8af687e6427fee59004d3:
  Linus Torvalds (1):
        Linux 2.6.31-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (3):
      amd64_edac: check only ECC bit in amd64_determine_edac_cap
      amd64_edac: fix ecc_enable_override handling
      amd64_edac: misc small cleanups

 drivers/edac/amd64_edac.c |   25 +++++++++++++++----------
 drivers/edac/amd64_edac.h |    2 +-
 2 files changed, 16 insertions(+), 11 deletions(-)


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

