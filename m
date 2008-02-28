Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYB1Mzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYB1Mzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 07:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYB1Mzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 07:55:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbYB1Mzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:55:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080227210003.484325295@gmail.com>
References: <20080227210003.484325295@gmail.com> <20080227205831.150784453@gmail.com>
To: gorcunov@gmail.com
Cc: dhowells@redhat.com, rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, zippel@linux-m68k.org,
       geert@linux-m68k.org, linux-m68k@vger.kernel.org, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: [RFC 05/10] mn10300: vmlinux.lds.S cleanup - use PAGE_SIZE, PERCPU macroses
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 28 Feb 2008 12:50:57 +0000
Message-ID: <21077.1204203057@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gorcunov@gmail.com wrote:

> Subject: [RFC 05/10] mn10300: vmlinux.lds.S cleanup - use PAGE_SIZE, PERCPU macroses
> X-RedHat-Spam-Score: -1.005 
> 
> This patch includes page.h header into liker script that
> allow us to use PAGE_SIZE macro instead of numeric constant
> 
> Also PERCPU macro is used instead of explicit section definition
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
