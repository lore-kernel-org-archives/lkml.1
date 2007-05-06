Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXEFVVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXEFVVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXEFVVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:21:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42921 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbXEFVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:21:05 -0400
Date: Sun, 6 May 2007 22:20:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] [TRIVIAL] Small cleanups for do_path_lookup (V2)
Message-ID: <20070506212058.GF13333@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <11784736762516-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11784736762516-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 01:47:54PM -0400, Josef 'Jeff' Sipek wrote:
> (For changes since V1, see the end of this email.)
> 
> The following 2 patches are trivial cleanups to do_path_lookup in namei.c.
> Since these changes are trivial, they can go into 2.6.22-rc1 without any
> problems.
> 
> Josef 'Jeff' Sipek (2):
>       fs: Fix indentation in do_path_lookup
>       fs: Use path_walk in do_path_lookup

Ok for both patches.
