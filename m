Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZJPQyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZJPQyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 12:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbZJPQyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 12:54:04 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:7713 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753744AbZJPQyB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 12:54:01 -0400
X-SpamScore: -14
X-BigFish: VPS-14(z21eWzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KRM9LM-02-JU2-02
X-M-MSG: 
Date: Fri, 16 Oct 2009 18:53:18 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: x86 <x86@kernel.org>, Doug Thompson <norsk5@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD64 EDAC fixes for 2.6.32-rc6
Message-ID: <20091016165318.GA22606@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Oct 2009 16:52:25.0492 (UTC) FILETIME=[09C1BD40:01CA4E81]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this last small fix. Hopefully, I've learned how to count
bits now.

Thanks.

The following changes since commit 012abeea669ea49636cf952d13298bb68654146a:
  Linus Torvalds (1):
        Linux 2.6.32-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (1):
      amd64_edac: fix DRAM base and limit extraction masks, v2

 drivers/edac/amd64_edac.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


