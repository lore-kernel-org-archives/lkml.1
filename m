Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbXGGKMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbXGGKMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 06:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbXGGKMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 06:12:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:50720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbXGGKMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 06:12:45 -0400
Date: Sat, 7 Jul 2007 12:12:31 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070707101231.GE29213@v2.random>
References: <20070706222651.GG5777@v2.random> <1183772822.21234.29.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183772822.21234.29.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 06:47:01PM -0700, Badari Pulavarty wrote:
> Hmm.. I didn't have any luck booting my machine with the patchset 
> (with 8k pagesize) :(
> 
> It fails to find the partition table on my hard drive.

I'm afraid I can't reproduce :( Best would be to track that code and
see what's being read from memory. 

Please also send me privately your .config so I may have more luck to
reproduce ;)
