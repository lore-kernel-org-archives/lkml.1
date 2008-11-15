Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYKONib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYKONib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 08:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYKONiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 08:38:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58881 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbYKONiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 08:38:03 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20081115237.317953894@firstfloor.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] [0/3] SCHED: Trivial scheduler fixes
Date: Sat, 15 Nov 2008 14:37:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[I posted this as a four patch series a few days ago.
One of the patches was apparently obsolete in linux-next -- I dropped
that one -- but the others still apply to linux-next as of today.]

This patch series fixes a couple of minor issues I noticed
while reading the scheduler code.

Patches against 2.6.28-rc4

-Andi
