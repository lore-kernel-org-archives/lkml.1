Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbYLSFMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYLSFMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYLSFLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:11:31 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42898 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYLSFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:11:28 -0500
From: Becky Bruce <beckyb@kernel.crashing.org>
To: mingo@elte.hu, jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org
Subject: swiotlb highmem for ppc series
Date: Thu, 18 Dec 2008 23:11:11 -0600
Message-Id: <1229663480-10757-1-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218210231.GB24271@elte.hu>
References: <20081218210231.GB24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Jeremy,

For reference, here's the set of patches I've been testing on powerpc
using swiotlb with HIGHMEM enabled. I think if we can deal with the
issues I mentioned in my previous mail, we should be able to use the
patch series Jeremy published on ppc - I'm just sticking this out here
since I'm about to fall off the internet for a while. I'll look at
getting your code working on ppc as soon as I'm back online.

Cheers,
Becky

