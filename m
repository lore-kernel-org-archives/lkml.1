Return-Path: <linux-kernel-owner+w=401wt.eu-S939323AbXHMXzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939323AbXHMXzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765124AbXHMXzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:55:20 -0400
Received: from ozlabs.org ([203.10.76.45]:41491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762171AbXHMXzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:55:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18112.61275.563391.321131@cargo.ozlabs.ibm.com>
Date: Tue, 14 Aug 2007 09:55:07 +1000
From: Paul Mackerras <paulus@samba.org>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, linux-ppp@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [384/2many] MAINTAINERS - PPP PROTOCOL DRIVERS AND
	COMPRESSORS
In-Reply-To: <1187019325.10249.74.camel@localhost>
References: <46bffb62.YUHsMJB9NIlhwots%joe@perches.com>
	<18112.9870.744182.247752@cargo.ozlabs.ibm.com>
	<1187019325.10249.74.camel@localhost>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches writes:

> On Mon, 2007-08-13 at 19:38 +1000, Paul Mackerras wrote:
> > Except for drivers/net/ppp_synctty.c.
> 
> It seems poor form to have 5 file entries where 1 would do.
> 
> Would renaming this one file to pppsynctty.c work?

It seems poor form to have to rename the file just because of a
deficiency in the tools.

Paul.
