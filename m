Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYCXXL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYCXXL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYCXXLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:11:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbYCXXLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:11:18 -0400
Date: Mon, 24 Mar 2008 16:10:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Subject: Re: +
 netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch added
 to -mm tree
Message-Id: <20080324161045.045ef5c8.akpm@linux-foundation.org>
In-Reply-To: <20080324.155652.218552935.davem@davemloft.net>
References: <200803242231.m2OMV6Cv028654@imap1.linux-foundation.org>
	<20080324.155652.218552935.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008 15:56:52 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: akpm@linux-foundation.org
> Date: Mon, 24 Mar 2008 15:31:06 -0700
> 
> > Subject: netdev: cassini: use shorter list_splice_init() macro for brevity
> > From: "Robert P. J. Day" <rpjday@crashcourse.ca>
> > 
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> This was applied to net-2.6.26 yesterday,

It wasn't in
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git two
hours ago.

> please drop.

That's OK - I'll routinely apply patches which might have already been applied
elsewhere and I'll drop them again when they turn up in a pull.  It turns
out to be less work this way than scrabbling around in mailing lists and
git trees on a per-patch basis.

