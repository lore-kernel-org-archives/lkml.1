Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYCXXVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYCXXVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYCXXVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:21:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53912
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755972AbYCXXVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:21:39 -0400
Date: Mon, 24 Mar 2008 16:21:38 -0700 (PDT)
Message-Id: <20080324.162138.50436206.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Subject: Re: +
 netdev-cassini-use-shorter-list_splice_init-macro-for-brevity.patch added
 to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080324161045.045ef5c8.akpm@linux-foundation.org>
References: <200803242231.m2OMV6Cv028654@imap1.linux-foundation.org>
	<20080324.155652.218552935.davem@davemloft.net>
	<20080324161045.045ef5c8.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 24 Mar 2008 16:10:45 -0700

> On Mon, 24 Mar 2008 15:56:52 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: akpm@linux-foundation.org
> > Date: Mon, 24 Mar 2008 15:31:06 -0700
> > 
> > > Subject: netdev: cassini: use shorter list_splice_init() macro for brevity
> > > From: "Robert P. J. Day" <rpjday@crashcourse.ca>
> > > 
> > > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > This was applied to net-2.6.26 yesterday,
> 
> It wasn't in
> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git two
> hours ago.

"net-2.6.26" not "net-2.6", this patch is not a bug fix but
rather a feature

net-2.6.26 is what is going into the linux-next tree
