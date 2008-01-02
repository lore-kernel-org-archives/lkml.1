Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbYABWFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbYABWFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYABWFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:05:40 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:56309 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYABWFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:05:39 -0500
Date: Wed, 2 Jan 2008 17:05:19 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] UML woes in 2.6.24-rc6-mm1
Message-ID: <20080102220519.GA10137@c2.user-mode-linux.org>
References: <E1JA7m0-0007nP-Fi@pomaz-ex.szeredi.hu> <20080102200621.GB8847@c2.user-mode-linux.org> <E1JAAZt-0008F8-An@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JAAZt-0008F8-An@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 09:52:41PM +0100, Miklos Szeredi wrote:
> 32bit UML, 64bit host, config attached.

Hadn't tried that, but that works here too.

I'll see if your config reproduces it.

> Can't reproduce with plain -rc6.

Feel like bisecting -mm1?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
