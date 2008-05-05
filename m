Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYEEJ6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYEEJ6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbYEEJzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:55:37 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38355 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349AbYEEJze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:55:34 -0400
Message-Id: <20080505095440.820370974@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 05 May 2008 11:54:41 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [patch 00/15] VFS fixes and cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are VFS/filesystem fix and cleanup patches in preparation for
the path_* API and AppArmor.

If there are no objections, please apply.

Thanks,
Miklos

--
