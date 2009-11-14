Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZKNLsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZKNLsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 06:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbZKNLsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 06:48:33 -0500
Received: from sh.osrg.net ([192.16.179.4]:53000 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbZKNLsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 06:48:15 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/3] IOMMU initialization cleanups
Date: Sat, 14 Nov 2009 20:46:35 +0900
Message-Id: <1258199198-16657-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Nov 2009 20:48:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor cleanups against tip.


