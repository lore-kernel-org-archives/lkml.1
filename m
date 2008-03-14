Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYCNATV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYCNATV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbYCNATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:19:10 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52693 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbYCNATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:19:09 -0400
Message-Id: <200803140015.m2E0Fgn8004015@www262.sakura.ne.jp>
Subject: Re: fix for boot-time mnt_want_write() bug
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2008 09:15:42 +0900
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp> <1205291010.9828.60.camel@nimitz.home.sr71.net> <20080311202212.9fe1e5c1.akpm@linux-foundation.org> <1205313918.8514.215.camel@twins> <20080312165218.GB613@parisc-linux.org> <200803130021.m2D0LlFm005300@www262.sakura.ne.jp> <1205440916.4971.58.camel@nimitz.home.sr71.net>
In-Reply-To: <1205440916.4971.58.camel@nimitz.home.sr71.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The patch solved mnt_want_write() bug in my environment.

Thank you.
