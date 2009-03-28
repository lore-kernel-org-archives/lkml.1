Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbZC1T2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbZC1T2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZC1T2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:28:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbZC1T2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:28:12 -0400
Date: Sat, 28 Mar 2009 12:24:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Arne de Bruijn <kernelbt@arbruijn.dds.nl>
Subject: Re: [PATCH] Fix suid_dumpable and lease-break-time sysctls
Message-Id: <20090328122429.574fded3.akpm@linux-foundation.org>
In-Reply-To: <20090328122254.58f6becb.akpm@linux-foundation.org>
References: <20090327133138.GJ8014@parisc-linux.org>
	<20090328122254.58f6becb.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 12:22:54 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > Arne de Bruijn points out in Bugzilla 12953 that commit
> > 76fdbb25f963de5dc1e308325f0578a2f92b1c2d mistakenly limits
> > lease-break-time instead of suid_dumpable.
> > 
> > Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> It would be nice to include the
> 
> Reported-by: Arne de Bruijn <kernelbt@arbruijn.dds.nl>
> 
> And to cc the reporter, please.
> 
> Also, please include the bugzilla URL
> (http://bugzilla.kernel.org/show_bug.cgi?id=12953) in the changelog. 
> Sometimes people will go through the commit logs closing off bugzilla
> reports for us, and this makes their task simpler.
> 

err, OK, minor reading comprehension problems there.  I need a nap.
