Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYLEEoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYLEEoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 23:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYLEEnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 23:43:50 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57946 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750773AbYLEEnt (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 23:43:49 -0500
Date: Fri, 05 Dec 2008 15:43:39 +1100
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.28
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081205044339.65ECC58ADC07@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit feaf3848a813a106f163013af6fcf6c4bfec92d9:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      [XFS] Fix hang after disallowed rename across directory quota domains

 fs/xfs/xfs_rename.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
