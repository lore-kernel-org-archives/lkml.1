Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYBDOmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYBDOmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYBDOmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:42:11 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45228 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYBDOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:42:10 -0500
Message-Id: <20080204144142.002127391@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 15:41:42 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [patch 0/3] fuse: writable mmap
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is short series for fuse writable mmap support.

The first two patches are small additions to mm infrastructure.  The
third is a large patch for fuse.  It also depends on the "mm: bdi:
export BDI attributes in sysfs" series.

I don't mind if this goes into 2.6.25 (guess, that depends on whether
the bdi things go).

Thanks,
Miklos

--
