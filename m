Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbXJAVxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbXJAVxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXJAVxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:53:42 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51808 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbXJAVxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:53:41 -0400
Date: Mon, 1 Oct 2007 23:53:30 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-10-01-04-09.tar.gz uploaded
In-Reply-To: <47016AFB.7040307@googlemail.com>
Message-ID: <Pine.LNX.4.64.0710012352450.22331@twin.jikos.cz>
References: <200710011115.l91BFRvg012762@imap1.linux-foundation.org>
 <47016AFB.7040307@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Gabriel C wrote:

> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-10-01-04-09.tar.gz
> I have a question about these snapshots , what is the right way to apply 
> the patches ? some magic script ? =)

There is a 'series' file, which tells you the correct order. If you are 
planning to make any patches on top of mm, you should use quilt for this.

-- 
Jiri Kosina
