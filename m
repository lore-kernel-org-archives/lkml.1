Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXA3RB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXA3RB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965628AbXA3RB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:01:57 -0500
Received: from [198.99.130.12] ([198.99.130.12]:57649 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965626AbXA3RB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:01:57 -0500
Date: Tue, 30 Jan 2007 11:54:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix indentation-related breakage in Kconfig.i386
Message-ID: <20070130165441.GA5835@ccure.user-mode-linux.org>
References: <E1HBsxY-0002NE-Uo@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HBsxY-0002NE-Uo@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:23:40PM +0000, Al Viro wrote:
> Kconfig recognizes the end of help text by receding indentation depth.
> Recent patch had broken HOST_VMSPLIT_... choice in arch/um/Kconfig.i386 -
> all alternatives are interpreted as part of help text now.

Thanks - I was trying to figure out what Kconfig was moaning about there...

				Jeff

-- 
Work email - jdike at linux dot intel dot com
