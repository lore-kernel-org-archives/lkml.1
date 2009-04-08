Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbZDHF5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbZDHF5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbZDHF5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:57:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756704AbZDHF5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:57:23 -0400
Date: Tue, 7 Apr 2009 22:54:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Chiang <achiang@hp.com>
Cc: Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-Id: <20090407225457.86f8a458.akpm@linux-foundation.org>
In-Reply-To: <20090408054612.GA6744@ldl.fc.hp.com>
References: <20090408003921.GA5054@ldl.fc.hp.com>
	<20090408010331.GB10768@sgi.com>
	<20090408054612.GA6744@ldl.fc.hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 23:46:12 -0600 Alex Chiang <achiang@hp.com> wrote:

> * Robin Holt <holt@sgi.com>:
> > Don't know if this answers your problem, but I use the tools from
> > emdebian and they do not suffer from the problems you list below.
> 
> Wow, this seems _much_ simpler. Once you get the toolchain
> installed, all you have to do is set ARCH and CROSS_COMPILE
> appropriately?
> 
> I guess the question remains for Andrew. Since I pretty much did
> all the work needed to update his cross-compiler repo, is there
> still value in it?

We would benefit very much from having someone who actually maintains a
suite of cross-compilers for kernel developers.

Yes, the stuff I put together is very old and at the time crosstool was
horridly hard to use.  Hardly any combinations of anything actually
worked - what you see there is about 5% of the toolchains I had to
build.  Apparently is has become better.

> Or shall we just recommend emdebian to everyone? :)

That sounds suspiciously like "thou shalt use debian".  I was so
traumatised by dselect ten years ago that I don't think I could afford
the therapy bills.

