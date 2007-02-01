Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXBARD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXBARD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbXBARD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:03:59 -0500
Received: from [198.99.130.12] ([198.99.130.12]:38548 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXBARD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:03:58 -0500
Date: Thu, 1 Feb 2007 11:56:33 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uml-i386: fix build breakage with CONFIG_HIGHMEM
Message-ID: <20070201165633.GA5318@ccure.user-mode-linux.org>
References: <E1HCcN6-0007T7-0K@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HCcN6-0007T7-0K@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 01:53:04PM +0000, Al Viro wrote:
> missing helper used by arch/i386/mm/highmem.c, which is pulled
> into build on that configuration.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

ACK

	Jeff

-- 
Work email - jdike at linux dot intel dot com
