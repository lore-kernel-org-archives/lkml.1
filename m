Return-Path: <linux-kernel-owner+w=401wt.eu-S965026AbXC0GUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026AbXC0GUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965268AbXC0GUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:20:53 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41792 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026AbXC0GUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:20:51 -0400
Date: Mon, 26 Mar 2007 22:20:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: James Simmons <jsimmons@infradead.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fbdev sysfs imrovements
Message-Id: <20070326222039.feb9216d.akpm@linux-foundation.org>
In-Reply-To: <17928.46653.30238.153536@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.64.0703192055090.27580@pentafluge.infradead.org>
	<20070326195807.184474d7.akpm@linux-foundation.org>
	<17928.46653.30238.153536@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 16:14:21 +1000 Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > http://userweb.kernel.org/~akpm/s5000489.jpg (the oops is the usual powerpc
> > mess)
> 
> Why do you have xmon enabled if you don't have any way to talk to it?
> 

gawd knows - I've been dragging that config along for over a year.

Maybe I subconsciously like seeing the mess it makes?
