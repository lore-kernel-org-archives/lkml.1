Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab0BCVjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:39:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42209 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806Ab0BCVjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:39:16 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <201002031039.710275915@firstfloor.org>
To: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: [PATCH] [0/4] SLAB: Fix a couple of slab memory hotadd issues
Date: Wed,  3 Feb 2010 22:39:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes various problems in slab found during memory hotadd testing.

All straight forward bug fixes, so could be still .33 candidates.

-Andi

