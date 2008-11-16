Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbYKPADz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbYKPADz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYKPADp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:03:45 -0500
Received: from mx1.suse.de ([195.135.220.2]:44594 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbYKPADp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:03:45 -0500
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: [RFC] Add dev.mem.restricted sysctl
Date: Sun, 16 Nov 2008 01:03:41 +0100
Message-Id: <1226793823-32360-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the first patch is only a small cleanup, the second patch adds a
new sysctl dev.mem.restricted. See that patch for a description why I
think that sysctl is needed.

Please give feedback and review. Thanks!


Signed-off-by: Bernhard Walle <bwalle@suse.de>


