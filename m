Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0CHU7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:59:33 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50451 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab0CHU71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:59:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5914"; a="35832020"
Subject: [GIT PULL] fix for msm_sdcc MMC driver for 2.6.34-rc1
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 12:58:56 -0800
Message-ID: <1268081936.14857.60.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just one small trivial fix.

The following changes since commit 6b7b284958d47b77d06745b36bc7f36dab769d9b:
  Linus Torvalds (1):
        Linux 2.6.33-rc2

are available in the git repository at:

  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-mmc_sdcc

Roel Kluin (1):
      msm_sdcc.c: missing brackets in msmsdcc_resume()

 drivers/mmc/host/msm_sdcc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)



