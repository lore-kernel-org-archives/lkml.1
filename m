Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZINUSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZINUSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbZINUSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:18:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42009 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbZINUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:18:06 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200909141018.915641783@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org
Subject: [PATCH] [0/5] kbuild: A couple of Kbuild fixes/improvements
Date: Mon, 14 Sep 2009 22:18:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I sent those some time ago, but nobody seems to have merged them. Sam?
They are all 2.6.32 canidated.

Some build system patches that accumulated in my tree:

- Fix mcount handling
- Fix gold linker support
- Add some gcc 4.5 support

One will address the problem Dave A. reported some time ago.

-Andi
