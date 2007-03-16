Return-Path: <linux-kernel-owner+w=401wt.eu-S2992448AbXCPXCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992448AbXCPXCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992449AbXCPXCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:02:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:35205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992448AbXCPXCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:02:18 -0400
Date: Fri, 16 Mar 2007 16:00:31 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [stable] [PATCH] UML - arch_prctl should set thread fs
Message-ID: <20070316230031.GA13798@kroah.com>
References: <20070316161015.GA7948@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316161015.GA7948@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 12:10:15PM -0400, Jeff Dike wrote:
> [ This missed getting into -stable the first time I sent it ]

That's because it doesn't apply at all to the current 2.6.20.3 kernel
tree.  Can you rediff it for that one so that we can apply it properly?

thanks,

greg k-h
