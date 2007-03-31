Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXCaDQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXCaDQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964863AbXCaDQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:16:35 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:60280 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834AbXCaDQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:16:34 -0400
Date: Fri, 30 Mar 2007 23:12:52 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] [PATCH] uml: fix static linking for real
Message-ID: <20070331031252.GA11746@c2.user-mode-linux.org>
References: <20070331012027.24884.85252.stgit@americanbeauty.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331012027.24884.85252.stgit@americanbeauty.home.lan>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 03:20:27AM +0200, Paolo 'Blaisorblade' Giarrusso wrote:
> There was a typo in commit 7632fc8f809a97f9d82ce125e8e3e579390ce2e5, preventing
> it from working - 32bit binaries crashed hopelessly before the below fix and
> work perfectly now.
> Merge for 2.6.21, please.

ACK.

	Jeff

-- 
Work email - jdike at linux dot intel dot com
