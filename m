Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbXJREUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbXJREUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXJREU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:20:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067AbXJREU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:20:27 -0400
Date: Wed, 17 Oct 2007 21:20:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/21] KGDB: Request to merge KGDB
Message-Id: <20071017212025.d8a52694.akpm@linux-foundation.org>
In-Reply-To: <4713B238.4030409@windriver.com>
References: <4713B238.4030409@windriver.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 13:32:24 -0500 Jason Wessel <jason.wessel@windriver.com> wrote:

> This is a request to merge KGDB into the mainline kernel.  

This won't work very well.  There's a lot of review work to be done here,
and a lot of it by busy architecture maintainers.  Expecting people to do
all this review and test work late in the merge window when they're all
madly scrambling to get their bugs^Wpatches into mainline is not reasonable.
This should all have started a month ago.

So we're looking at a 2.6.25 merge for this work.  After this round of
review has settled, please upissue the patches and keep linux-arch (cc'ed
here) copied on everything, thanks.

