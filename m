Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZBHW3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZBHW3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZBHW3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:29:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45792 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZBHW3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:29:00 -0500
Date: Sun, 8 Feb 2009 17:28:59 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-xfs <linux-xfs@oss.sgi.com>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090208222859.GA2532@infradead.org>
References: <1234011974.7435.11.camel@champagne.cantina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234011974.7435.11.camel@champagne.cantina>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 02:06:13PM +0100, Alessandro Bono wrote:
> Feb  7 12:43:12 champagne kernel: [ 5828.167041] ------------[ cut
> here ]------------
> Feb  7 12:43:12 champagne kernel: [ 5828.167048] kernel BUG at
> fs/buffer.c:470!

Per
http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-allstable.git;a=blob;f=fs/buffer.c;h=665d446b25bc034241ef54c3c6b1d239c0ccf0f9;hb=d5b562330ec766292a3ac54ae5e0673610bd5b3d

line 470 in fs/buffer.c of 2.6.28.4 has a comment and no actual code.

What additional patches do you have applied?

