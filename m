Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbYCXXbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbYCXXbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYCXXbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:31:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbYCXXbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:31:38 -0400
Date: Mon, 24 Mar 2008 16:31:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Subject: Re: +
 netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch added
 to -mm tree
Message-Id: <20080324163105.154a031a.akpm@linux-foundation.org>
In-Reply-To: <20080324.162138.50436206.davem@davemloft.net>
References: <200803242231.m2OMV6Cv028654@imap1.linux-foundation.org>
	<20080324.155652.218552935.davem@davemloft.net>
	<20080324161045.045ef5c8.akpm@linux-foundation.org>
	<20080324.162138.50436206.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008 16:21:38 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Mon, 24 Mar 2008 16:10:45 -0700
> 
> > On Mon, 24 Mar 2008 15:56:52 -0700 (PDT)
> > David Miller <davem@davemloft.net> wrote:
> > 
> > > From: akpm@linux-foundation.org
> > > Date: Mon, 24 Mar 2008 15:31:06 -0700
> > > 
> > > > Subject: netdev: cassini: use shorter list_splice_init() macro for brevity
> > > > From: "Robert P. J. Day" <rpjday@crashcourse.ca>
> > > > 
> > > > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > 
> > > This was applied to net-2.6.26 yesterday,
> > 
> > It wasn't in
> > git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git two
> > hours ago.
> 
> "net-2.6.26" not "net-2.6", this patch is not a bug fix but
> rather a feature
> 
> net-2.6.26 is what is going into the linux-next tree

urgh.  I wish I had some algorithm for detecting when net-2.6.x+1 appears.

Perhaps you could create it on the day 2.6.x is released and leave it empty
for a while.  That way I'll notice when net-2.6.x vanishes and I can switch
to 2.6.x+1 immediately?


