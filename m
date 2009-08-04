Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbZHDKkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbZHDKkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932698AbZHDKkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:40:41 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57030 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbZHDKkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:40:40 -0400
X-SpamScore: -12
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNULN3-04-YT9-01
Date: Tue, 4 Aug 2009 12:40:14 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD64 EDAC fixes for 2.6.31-rc6
Message-ID: <20090804104014.GA1870@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 04 Aug 2009 10:40:15.0524 (UTC) FILETIME=[F3E74640:01CA14EF]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the last two AMD64 EDAC fixes for .31:

The following changes since commit ed680c4ad478d0fee9740f7d029087f181346564:
  Linus Torvalds (1):
        Linux 2.6.31-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Doug Thompson (2):
      amd64_edac: fix ECC checking
      amd64_edac: print debug statements only on error

 drivers/edac/amd64_edac.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

