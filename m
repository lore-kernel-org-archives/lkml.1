Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZFQRf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZFQRf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbZFQRfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:35:12 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54284 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212AbZFQRfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:35:10 -0400
Subject: [GIT PULL] Kmemleak fixes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 17 Jun 2009 18:35:03 +0100
Message-Id: <1245260103.11889.65.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2009 17:35:04.0862 (UTC) FILETIME=[F346DBE0:01C9EF71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the kmemleak branch? There are a few fixes that
were raised recently. Thanks.

The following changes since commit 65795efbd380a832ae508b04dba8f8e53f0b84d9:
  Linus Torvalds (1):
        Merge branch 'next-i2c' of git://aeryn.fluff.org.uk/bjdooks/linux

are available in the git repository at:

  git://linux-arm.org/linux-2.6.git kmemleak

Catalin Marinas (3):
      kmemleak: Only use GFP_KERNEL|GFP_ATOMIC for the internal allocations
      kmemleak: Rename kmemleak_panic to kmemleak_stop
      kmemleak: Fix some typos in comments

 mm/kmemleak.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

-- 
Catalin

