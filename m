Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbYFXXHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbYFXXHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYFXXHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:07:33 -0400
Received: from ozlabs.org ([203.10.76.45]:33765 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbYFXXHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:07:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18529.29291.150197.168137@cargo.ozlabs.ibm.com>
Date: Wed, 25 Jun 2008 08:17:15 +1000
From: Paul Mackerras <paulus@samba.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, cooloney@kernel.org, dev-etrax@axis.com,
       dhowells@redhat.com, gerg@uclinux.org, yasutake.koichi@jp.panasonic.com,
       linux-parisc@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-sh@vger.kernel.org, chris@zankel.net, linux-mips@linux-mips.org,
       ysato@users.sourceforge.jp, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm/ptrace.h userspace headers cleanup
In-Reply-To: <20080623174809.GE4756@cs181140183.pp.htv.fi>
References: <20080623174809.GE4756@cs181140183.pp.htv.fi>
X-Mailer: VM 8.0.9 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk writes:

> This patch contains the following cleanups for the asm/ptrace.h 
> userspace headers:

Acked-by: Paul Mackerras <paulus@samba.org>
