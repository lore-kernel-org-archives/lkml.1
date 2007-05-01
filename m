Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXEASLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXEASLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXEASLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:11:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbXEASLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:11:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0705012006050.27246@anakin> 
References: <Pine.LNX.4.64.0705012006050.27246@anakin>  <20070501174747.19112.1985.stgit@warthog.cambridge.redhat.com> <20070501174752.19112.82814.stgit@warthog.cambridge.redhat.com> 
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] AFS/AF_RXRPC: Miscellaneous fixes 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 01 May 2007 19:11:02 +0100
Message-ID: <27201.1178043062@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> I've just noticed another issue: if CONFIG_AFS_FS=y, the kernel build fails
> with

Can you send me the config you're using please?

David
