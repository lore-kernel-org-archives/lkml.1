Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbXHOKjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbXHOKjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXHOKiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:38:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:35298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbXHOKiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:38:54 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <200708151238.148026000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 2.6.22] [0/5] x86 updates for 2.6.22-stable
Date: Wed, 15 Aug 2007 12:38:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Should all go into the next stable release.

Two of the patches (cfi probe and rept fix) are only pending
for mainline (I hope Linus applies them today). They should
not go in before hitting mainline.

-Andi
