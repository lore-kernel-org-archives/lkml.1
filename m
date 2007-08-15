Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbXHOOV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbXHOOV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbXHOOVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:21:49 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:45587 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131AbXHOOVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:21:48 -0400
Date: Wed, 15 Aug 2007 10:21:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] UML: "extern inline" -> "static inline"
Message-ID: <20070815142125.GA5376@c2.user-mode-linux.org>
References: <20070814212533.GT18945@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814212533.GT18945@stusta.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 11:25:33PM +0200, Adrian Bunk wrote:
> "extern inline" will have different semantics with gcc 4.3.

Thanks, I'll send this in.

BTW, I killed off CONFIG_MODE_TT yesterday.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
