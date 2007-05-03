Return-Path: <linux-kernel-owner+w=401wt.eu-S1161987AbXECOVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161987AbXECOVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161989AbXECOVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:21:15 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:46638 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161987AbXECOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:21:14 -0400
Date: Thu, 3 May 2007 10:16:28 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: akpm@osdl.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 5/6] UML - Network and pcap cleanup
Message-ID: <20070503141628.GB5522@c2.user-mode-linux.org>
References: <20070501182159.GA8363@c2.user-mode-linux.org> <200705031532.44157.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705031532.44157.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 03:32:43PM +0200, Blaisorblade wrote:
> This is due to patch:
> "uml: drivers get release methods"
> this could be useful to check whether other such changes are needed, by 
> grepping for platform_device_unregister in exit paths, also for ubd driver.
> 
> That patch only fixed net_remove() and ubd_remove().

Yeah, good point - I'll have a look.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
