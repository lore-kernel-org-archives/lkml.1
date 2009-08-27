Return-Path: <linux-kernel-owner+w=401wt.eu-S1751228AbZH0PJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228AbZH0PJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZH0PJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:09:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:40773 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbZH0PJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:09:20 -0400
Message-Id: <20090827150051.846026837@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 27 Aug 2009 17:00:51 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/6] load-balancing and cpu_power
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

These are utterly untested patches, and even if they'd compile I guess they'll
balance your system straight like a banana. But it should show the direction
I'm wanting to take this thing.

I'll continue prodding at this, but wanted to put this out early so we don't
all start doing the same, and so that you can poke holes in it early.

