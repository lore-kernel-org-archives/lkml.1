Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbYHAXJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbYHAXJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYHAXI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:08:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYHAXI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:08:57 -0400
Date: Fri, 1 Aug 2008 16:06:24 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: stable@kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [stable] [PATCH 1/14] uml: fix build when SLOB is enabled
Message-ID: <20080801230624.GA22233@kroah.com>
References: <20080801224125.GA13727@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801224125.GA13727@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 06:41:25PM -0400, Jeff Dike wrote:
> >From 94409ded7768e15b0d0a5a172d611073c72308de Mon Sep 17 00:00:00 2001

These git commit ids don't match up to anything in Linus's tree at all
:(

Can you resend these patches with the git ids of the patches already in
Linus's tree so that we can properly match them up?

Oh, in the future it is simple to get patches into the -stable tree
automatically, just add:
	Cc: Stable <stable@kernel.org>
to the signed-off-by: area of the patch.  When it goes into Linus's
tree, it will be automatically sent to us for inclusion in the next
-stable release.

thanks,

greg k-h
