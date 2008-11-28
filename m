Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYK1FYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYK1FYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 00:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYK1FYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 00:24:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42488 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYK1FYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 00:24:03 -0500
Date: Fri, 28 Nov 2008 05:24:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v3 1/8] filesystem notification: create fs/notify to
	contain all fs notification
Message-ID: <20081128052402.GI28946@ZenIV.linux.org.uk>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com> <20081125172056.17115.19709.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125172056.17115.19709.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:20:57PM -0500, Eric Paris wrote:
> Adding yet another filesystem notification system it seemed like a good
> idea to clean up fs/ by creating an fs/notify and putting everything
> there.

	FWIW, passing -M to git-format-patch and friends is a damn good
idea - at least it would be immediately obvious from the posted diff
which files simply got moved as-is.  ~3KLines off the mail also wouldn't
hurt...
