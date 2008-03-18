Return-Path: <linux-kernel-owner+w=401wt.eu-S943949AbYCTAVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943949AbYCTAVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933206AbYCSXfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936149AbYCSXfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:43 -0400
Message-Id: <20080318185626.300130296@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 18 Mar 2008 19:56:26 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 0/4] fuse: writable mmap fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the requested fixes as incremental patches.  Also
mm-allow-not-updating-bdi-stats-in-end_page_writeback.patch is no
longer needed.

Thanks,
Miklos
