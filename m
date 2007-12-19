Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbXLSDbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbXLSDbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXLSDbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:31:48 -0500
Received: from [198.99.130.12] ([198.99.130.12]:55323 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXLSDbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:31:47 -0500
Date: Tue, 18 Dec 2007 22:30:56 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       Dave Young <hidave.darkstar@gmail.com>, Valdis.Kletnieks@vt.edu,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: 2.6.24-rc5-mm1 - wonky disk cache and CDROM behavior...
Message-ID: <20071219033056.GA11148@c2.user-mode-linux.org>
References: <20071217185213.d0d02149.akpm@linux-foundation.org> <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <30457.1197931451@turing-police.cc.vt.edu> <20071217145644.2d6374e4.akpm@linux-foundation.org> <11403.1197943676@turing-police.cc.vt.edu> <20071218023732.GA3215@darkstar.te-china.tietoenator.com> <26475.1198027341@redhat.com> <20071218180458.c80a0575.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218180458.c80a0575.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 06:04:58PM -0800, Andrew Morton wrote:
> Nobody seems to look after hppfs.  I'll resend the fat and hostfs patches to
> maintainers for a review, please.

It's mine - I'll take a look at it.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
