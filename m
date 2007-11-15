Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbXKOOlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbXKOOlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 09:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbXKOOlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 09:41:08 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:49907 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbXKOOlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 09:41:07 -0500
Date: Thu, 15 Nov 2007 09:40:21 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: EIP is at device_shutdown+0x32/0x60
Message-ID: <20071115144021.GB6285@c2.user-mode-linux.org>
References: <20071115091158.GB6216@localhost.sw.ru> <20071115014446.f943d835.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115014446.f943d835.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:44:46AM -0800, Andrew Morton wrote:
> Yes, all my test boxes did that - it's what I referred to in the releaee
> notes.  Greg is pondering the problem - seem he's the only person who
> cannot reproduce it ;)

UML does it reliably too, in case Greg is still looking for a way to
reproduce it...

				Jeff

-- 
Work email - jdike at linux dot intel dot com
