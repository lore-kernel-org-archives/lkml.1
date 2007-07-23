Return-Path: <linux-kernel-owner+w=401wt.eu-S1763396AbXGWQQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763396AbXGWQQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbXGWQPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:15:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55989 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXGWQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:15:52 -0400
Date: Mon, 23 Jul 2007 17:15:50 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, ericvh@gmail.com,
       rminnich@lanl.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net
Subject: Re: Plan 9 Resource Sharing Support - what is it?
Message-ID: <20070723161550.GJ21668@ftp.linux.org.uk>
References: <20070723075434.GA9162@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723075434.GA9162@elf.ucw.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 09:54:34AM +0200, Pavel Machek wrote:
>   Plan 9 Resource Sharing Support (9P2000) (Experimental) (NET_9P)
> [N/m/y/?] (NEW) ?
> 
> If you say Y here, you will get experimental support for
> Plan 9 resource sharing via the 9P2000 protocol.
> 
> See <http://v9fs.sf.net> for more information.
> 
> If unsure, say N.
> 
> What is "plan 9 resource sharing"? Some kind of mosix-like process
> migration? Could you explain it in two lines in Kconfig?

9P is the protocol used by Plan 9 remote/userland filesystem servers.
FUSE is its considerably more bloated and less sane analog.
