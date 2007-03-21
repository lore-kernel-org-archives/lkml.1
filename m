Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbXCUFvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbXCUFvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 01:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXCUFvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 01:51:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49476 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbXCUFvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 01:51:09 -0400
Date: Tue, 20 Mar 2007 21:47:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@outflux.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070320214714.0e584cd4.akpm@linux-foundation.org>
In-Reply-To: <20070320192016.GC22797@outflux.net>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<20070320103151.f65c81b6.randy.dunlap@oracle.com>
	<20070320192016.GC22797@outflux.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 12:20:16 -0700 Kees Cook <kees@outflux.net> wrote:

> I can't 
> get 2.6.21-rc4-mm1 to compile (with or without this fix):
> 
>   GEN     .version
> init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
> make: *** [.tmp_vmlinux1] Error 2

How'd you manage that?

Sam, I think this is a you-thing rather than a dwmw2-thing?
