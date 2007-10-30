Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbXJ3R50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbXJ3R50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXJ3R5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:57:19 -0400
Received: from [198.99.130.12] ([198.99.130.12]:43219 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbXJ3R5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:57:18 -0400
Date: Tue, 30 Oct 2007 13:56:28 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 3/4] UML - Implement get_wchan
Message-ID: <20071030175628.GA9279@c2.user-mode-linux.org>
References: <20071030172849.GA8367@c2.user-mode-linux.org> <1193766046.24844.19.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193766046.24844.19.camel@localhost>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 10:40:46AM -0700, Joe Perches wrote:
> Perhaps instead of unsigned long?
> 
> bool skipped_ip;	//delayed initialization

Ooh, I forgot we had bool.  I'll fix that in a later patch.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
