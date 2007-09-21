Return-Path: <linux-kernel-owner+w=401wt.eu-S1763920AbXIUXps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763920AbXIUXps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbXIUXpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:45:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45299 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756204AbXIUXpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:45:39 -0400
Date: Sat, 22 Sep 2007 00:52:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <ak@suse.de>, oliver.pntr@gmail.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/50] x86: add cpu codenames for Kconfig.cpu
Message-ID: <20070922005229.48bcdcca@the-village.bc.nu>
In-Reply-To: <20070921224539.GD8127@redhat.com>
References: <200709221231.836138000@suse.de>
	<20070921223202.2504813DCD@wotan.suse.de>
	<20070921224539.GD8127@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  >  config MPSC
>  >         bool "Intel P4 / older Netburst based Xeon"
>  >         help
> 
> sidenote: I always wondered what 'PSC' stood for ?

Produces Smoke and Cooks ?
