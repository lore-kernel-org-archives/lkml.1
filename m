Return-Path: <linux-kernel-owner+w=401wt.eu-S1764188AbYEFJOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764188AbYEFJOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbYEFJON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:14:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59477 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbYEFJOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:14:12 -0400
Message-Id: <20080506091327.259950960@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 May 2008 11:13:27 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 00/24] vfs: fixes and cleanups + add helpers to check r/o bind mounts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here it is again as a single series (without the ecryptfs one already
merged).

I've addressed Christoph's comments.

Thanks,
Miklos

--
