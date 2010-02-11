Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab0BKUyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:54:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36909 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab0BKUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:54:06 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20100211953.850854588@firstfloor.org>
To: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com, rientjes@google.com
Subject: [PATCH] [0/4] Update slab memory hotplug series
Date: Thu, 11 Feb 2010 21:53:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Should address all earlier comments (except for the funny cpuset
case which I chose to declare a don't do that)

Also this time hopefully without missing patches.

There are still some other issues with memory hotadd, but that's the 
current slab set.

The patches are against 2.6.32, but apply to mainline I believe.

-Andi
