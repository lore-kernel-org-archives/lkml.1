Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbZLBUJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbZLBUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZLBUJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:09:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:1546 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZLBUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:09:53 -0500
Subject: [GIT PULL] regulator fix for 2.6.32
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 20:09:53 +0000
Message-ID: <1259784593.3588.197.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Hope it's not too late. Please pull the following regulator bug fix for
2.6.32. This one fixes an oops in the WM831x ISINK driver.

Thanks

Liam 

---

The following changes since commit 2127816366e0ffbc1426fa69e7b9b2bebd2e2288:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/staging-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Mark Brown (1):
      regulator: Initialise wm831x structure pointor for ISINK driver

 drivers/regulator/wm831x-isink.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


