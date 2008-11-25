Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYKYA41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYKYA41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYKYAzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:18 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57336 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbYKYAzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:14 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/20] [MTD] Namespace cleanup for MTD drivers
Date: Tue, 25 Nov 2008 02:54:51 +0200
Message-Id: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

It has come to my attention that many MTD drivers needlessly define
their module entry points as global symbols. The patch series that
follows fixes all such places that I was able to identify. Please
consider.

Note that I'm not subscribed to linux-mtd, so please Cc: me when
replying.

Thanks,
Dmitri Vorobiev
