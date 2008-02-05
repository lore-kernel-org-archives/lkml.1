Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbYBEXbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbYBEXbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbYBEXbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:31:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39269 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbYBEXbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:31:08 -0500
Date: Tue, 5 Feb 2008 15:29:16 -0800
From: Greg KH <greg@kroah.com>
To: David Newall <davidn@davidnewall.com>
Cc: Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080205232916.GA9040@kroah.com>
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <20080203124849.0226560f@weinigel.se> <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com> <47A5F418.6030104@weinigel.se> <20080203231530.GB15692@kroah.com> <courier.47A8EDDC.0000785F@hawking.rebel.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <courier.47A8EDDC.0000785F@hawking.rebel.net.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 09:44:36AM +1030, David Newall wrote:
> A kernel module is akin to a process.  It uses services of the kernel 
> without being part of the kernel.

No Linux does not work like this at all.

Like Alan said, you really need to brush up on your basic IP law, as
well as some basic technical issues regarding how the Linux kernel
works before trying to make statements like this.

Also see the various issues surrounding "loadable modules" and Samba,
and how they have successfully enforced the "linking" and other type
issues that are being discussed here (shims, "GPL condoms", etc.) with
regards to the GPLv2 and derivative works.

good luck,

greg k-h
