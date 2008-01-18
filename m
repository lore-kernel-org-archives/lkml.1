Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYARCgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYARCgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbYARCgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:36:37 -0500
Received: from waste.org ([66.93.16.53]:40533 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbYARCgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:36:36 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 12] random cleanups for 2.6.25
Message-Id: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:42 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a collection of drivers/char/random.c cleanups and fixes for
2.6.25. Please apply.

