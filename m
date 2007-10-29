Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbXJ2Qct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbXJ2Qct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbXJ2Qcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:32:39 -0400
Received: from [198.99.130.12] ([198.99.130.12]:36551 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759321AbXJ2Qci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:32:38 -0400
Date: Mon, 29 Oct 2007 12:32:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 merge fallout: uml
Message-ID: <20071029163229.GC7552@c2.user-mode-linux.org>
References: <20071029043116.GW8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029043116.GW8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 04:31:16AM +0000, Al Viro wrote:
> Don't undef __i386__/__x86_64__ in uml anymore, make sure that (few) places
> that required adjusting the ifdefs got those.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Jeff Dike <jdike@linux.intel.com>
