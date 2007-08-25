Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbXHYV3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbXHYV3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 17:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXHYV3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 17:29:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48281 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXHYV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 17:29:22 -0400
Date: Sat, 25 Aug 2007 22:29:20 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FS: Make RAMFS both selectable and tristate.
Message-ID: <20070825212920.GB21089@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0708251538320.29214@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708251538320.29214@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 03:40:23PM -0400, Robert P. J. Day wrote:
> 
> Allow RAMFS to be user-selectable, and to be built as a module.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   given that the help content for that option suggests it can be built
> as a module, it just makes sense to make it selectable and tristate,
> unless someone has a compelling argument against it.

How about "check if the kernel builds if you do that"?
