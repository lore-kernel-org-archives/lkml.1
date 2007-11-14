Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbXKNCEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbXKNCEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXKNCEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:04:38 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4736 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbXKNCEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:04:38 -0500
Subject: [PATCH] - [0/15] - remove defconfig ptr comparisons to 0
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:04:35 -0800
Message-Id: <1195005876.5163.85.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

