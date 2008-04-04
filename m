Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYDDGmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYDDGmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYDDGmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:42:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbYDDGl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:41:59 -0400
Date: Thu, 3 Apr 2008 23:34:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Alchemy: move UART platform code to its proper place
Message-Id: <20080403233440.9b920466.akpm@linux-foundation.org>
In-Reply-To: <20080404062924.GA12086@linux-mips.org>
References: <200804040002.53757.sshtylyov@ru.mvista.com>
	<20080404062924.GA12086@linux-mips.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008 07:29:25 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:

> On Fri, Apr 04, 2008 at 12:02:53AM +0400, Sergei Shtylyov wrote:
> 
> > Move the code registering the Alchemy UART platform devices from drivers/serial/
> > to its proper place, into the Alchemy platform code.  Fix the related Kconfig
> > entry, while at it...
> > 
> > Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> > 
> > ---
> > Ralf, could you take this patch thru your queue -- it ahould apply atop of my
> > former #include /extern cleanup?
> > 
> > I don't know how the platform code ended up accepted into the serial drivers in
> > the first place -- it's high time to amend this.
> 
> Andrew, I'd like to queue this patch, ok?

Sure..
