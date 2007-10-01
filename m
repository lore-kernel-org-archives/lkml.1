Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXJAWP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXJAWP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXJAWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:15:51 -0400
Received: from twin.jikos.cz ([213.151.79.26]:53446 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbXJAWPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:15:51 -0400
Date: Tue, 2 Oct 2007 00:15:44 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-10-01-04-09.tar.gz uploaded
In-Reply-To: <47016FEE.6090608@googlemail.com>
Message-ID: <Pine.LNX.4.64.0710020015060.22331@twin.jikos.cz>
References: <200710011115.l91BFRvg012762@imap1.linux-foundation.org>
 <47016AFB.7040307@googlemail.com> <Pine.LNX.4.64.0710012352450.22331@twin.jikos.cz>
 <47016FEE.6090608@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Gabriel C wrote:

> >>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-10-01-04-09.tar.gz
> > There is a 'series' file, which tells you the correct order. If you are 
> > planning to make any patches on top of mm, you should use quilt for this.
> Thx for your quick reply  but I cannot find any series file in this tarball.

$ tar xzvf broken-out-2007-10-01-04-09.tar.gz | grep series | head -1
series

-- 
Jiri Kosina
