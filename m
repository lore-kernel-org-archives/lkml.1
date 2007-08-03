Return-Path: <linux-kernel-owner+w=401wt.eu-S1764648AbXHCRt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764648AbXHCRt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763573AbXHCRtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:49:50 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:50572 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763433AbXHCRtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:49:49 -0400
Message-Id: <20070803174425.998083527@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 19:44:26 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/11] fuse updates
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Various fuse bits.  Some of these are in preparation for the writable
mmap support, but do stand on their own.

All this is 2.6.24 material.

Thanks,
Miklos
--
