Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYKGUjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYKGUjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYKGUjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:39:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52177 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYKGUjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:39:31 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, npiggin@suse.de
Subject: [PATCH 0/4] Fix vmalloc regression
Date: Fri,  7 Nov 2008 20:35:50 -0200
Message-Id: <1226097354-7523-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

This is the whole set of patches I was talking about.
Patch 3 is the one that in fact fixes the problem
Patches 1 and 2 are debugging aids I made use of, and could be possibly
useful to others
Patch 4 removes guard pages entirely for non-debug kernels, as we have already
previously discussed.

Hope it's all fine.


