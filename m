Return-Path: <linux-kernel-owner+w=401wt.eu-S1763941AbYF0U5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763941AbYF0U5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763604AbYF0U45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:56:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866AbYF0U4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:56:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, cooloney@kernel.org,
       dev-etrax@axis.com, dhowells@redhat.com, gerg@uclinux.org,
       yasutake.koichi@jp.panasonic.com, linux-parisc@vger.kernel.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org, linux-sh@vger.kernel.org,
       chris@zankel.net, linux-mips@linux-mips.org, ysato@users.sourceforge.jp,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm/ptrace.h userspace headers cleanup
In-Reply-To: Adrian Bunk's message of  Monday, 23 June 2008 20:48:09 +0300 <20080623174809.GE4756@cs181140183.pp.htv.fi>
References: <20080623174809.GE4756@cs181140183.pp.htv.fi>
X-Shopping-List: (1) Ingenious competition rice
   (2) Famous persecuters
   (3) Disorienting rectractors
   (4) Ostentatious rectractors
   (5) Prosthetic tape
Message-Id: <20080627204953.DA76515427E@magilla.localdomain>
Date: Mon, 23 Jun 2008 13:08:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That all looks fine to me, though I won't claim to have paid close
attention to the nits in the various odd archs' files.

Thanks,
Roland
