Return-Path: <linux-kernel-owner+w=401wt.eu-S965225AbXC0GOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225AbXC0GOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965268AbXC0GOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:14:31 -0400
Received: from ozlabs.org ([203.10.76.45]:44645 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965225AbXC0GOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:14:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17928.46653.30238.153536@cargo.ozlabs.ibm.com>
Date: Tue, 27 Mar 2007 16:14:21 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Simmons <jsimmons@infradead.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fbdev sysfs imrovements
In-Reply-To: <20070326195807.184474d7.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703192055090.27580@pentafluge.infradead.org>
	<20070326195807.184474d7.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> http://userweb.kernel.org/~akpm/s5000489.jpg (the oops is the usual powerpc
> mess)

Why do you have xmon enabled if you don't have any way to talk to it?

Paul.
