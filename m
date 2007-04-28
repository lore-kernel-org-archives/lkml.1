Return-Path: <linux-kernel-owner+w=401wt.eu-S1163374AbXD1SAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163374AbXD1SAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163361AbXD1R7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:59:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:34666 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031228AbXD1R6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:51 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070428758.455116000@suse.de>
To: linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [0/22] x86 candidate patches for review II: 64bit relocatable kernel
Date: Sat, 28 Apr 2007 19:58:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here are the patches to support the relocatable kernel on x86-64. All done
by Eric Biederman and Vivek Goyal.  Following i386. Also includes lots
of cleanup to various boot paths.

Vivek already posted them a couple of time.

Please review.

-Andi

