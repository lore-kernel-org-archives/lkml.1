Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYIEKVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYIEKVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbYIEKV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:21:27 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:51198 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYIEKV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:21:26 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="74640979"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] ASoC Blackfin supporting (v2)
Date: Fri,  5 Sep 2008 18:21:33 +0800
Message-Id: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Mark,

With Cliff's effort, we update this patch series quickly according to
your review.

v1-v2:
 - move ASoC Blackfin Kconfig and Makefile patch to be the last one
   in the series
 - fix coding style issues
 - The SND_SOC_DAFIMT_LEFT_J: ought to be default
 - fix other minor issues

v0-v1:
 - fix coding style issues
 - use latest ASoC API
 - split the whole patch into this 9 patches in a patchset

Thanks a lot
-Bryan
