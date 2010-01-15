Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0AOKHU (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 05:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476Ab0AOKHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 05:07:19 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:15733 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0AOKHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 05:07:17 -0500
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWA9FL-02-DTX-02
X-M-MSG: 
Date: Fri, 15 Jan 2010 11:06:58 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Roel Kluin <roel.kluin@gmail.com>
Subject: [GIT PULL] AMD64 EDAC fix for 2.6.33-rc5
Message-ID: <20100115100658.GA32758@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Jan 2010 10:06:59.0268 (UTC) FILETIME=[79C9C840:01CA95CA]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following small fix.

The following changes since commit 7284ce6c9f6153d1777df5f310c959724d1bd446:
  Linus Torvalds (1):
        Linux 2.6.33-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Roel Kluin (1):
      amd64_edac: Ensure index stays within bounds in amd64_get_scrub_rate

 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
 Systems  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

