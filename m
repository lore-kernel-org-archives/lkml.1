Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXLEQSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXLEQSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXLEQSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:18:40 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53913 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbXLEQSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:18:39 -0500
Date: Wed, 5 Dec 2007 11:18:25 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] no need to mess with KBUILD_CFLAGS on uml-i386 anymore
Message-ID: <20071205161825.GA7152@c2.user-mode-linux.org>
References: <20071205083615.GF8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205083615.GF8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 08:36:15AM +0000, Al Viro wrote:
> 	Now that X86_32 is provided on Kconfig level for uml-i386, there's
> no need to play with it explicitly on Makefile level anymore.

ACK

	Jeff

-- 
Work email - jdike at linux dot intel dot com
