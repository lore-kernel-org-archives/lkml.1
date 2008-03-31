Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbYCaOwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbYCaOwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761201AbYCaOwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:52:32 -0400
Received: from [198.99.130.12] ([198.99.130.12]:35812 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761183AbYCaOwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:52:31 -0400
Date: Mon, 31 Mar 2008 10:52:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [2.6 patch] remove include/asm-um/keyboard.h
Message-ID: <20080331145210.GJ6540@c2.user-mode-linux.org>
References: <20080330224031.GG28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080330224031.GG28445@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 01:40:31AM +0300, Adrian Bunk wrote:
> This patch removes the unused and broken (the normal asm/keyboard.h 
> files no longer exists) include/asm-um/keyboard.h
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, I'll forward this on.

	     	     Jeff

-- 
Work email - jdike at linux dot intel dot com
