Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbXKTRGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbXKTRGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759547AbXKTRGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:06:30 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:52540 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbXKTRG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:06:29 -0500
Date: Tue, 20 Nov 2007 12:05:51 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 08/59] arch/um: Add missing "space"
Message-ID: <20071120170551.GB7211@c2.user-mode-linux.org>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com> <fbeb04f6d7134565611741ad0148e1b401362ef9.1195454434.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbeb04f6d7134565611741ad0148e1b401362ef9.1195454434.git.joe@perches.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 05:48:00PM -0800, Joe Perches wrote:
> -		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args"
> +		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "

Applied, thanks.

		Jeff

-- 
Work email - jdike at linux dot intel dot com
