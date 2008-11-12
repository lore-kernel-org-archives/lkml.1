Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbYKLM1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbYKLM1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYKLM1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:27:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYKLM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:27:41 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20081112145.328971960@firstfloor.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: [PATCH] [0/4] SCHED: Trivial scheduler fixes
Date: Wed, 12 Nov 2008 13:45:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series fixes a couple of minor issues I noticed
while reading the scheduler code.

Patches against 2.6.28-rc4

-Andi
