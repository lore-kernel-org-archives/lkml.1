Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbZANOb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbZANOb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbZANObs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:31:48 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:60398 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZANObs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:31:48 -0500
Date: Wed, 14 Jan 2009 17:31:55 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] alpha: fixes for 2.6.29
Message-ID: <20090114143154.GA10788@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are critical bug fixes for nautilus and marvel platforms,
plus a couple of trivial patches (.gitignore vmlinux.lds and inlining
of pte_alloc_one_kernel).
Vmalloc fix is already in the -mm tree, so not included here.

Ivan.
