Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbYEOEkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbYEOEkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 00:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYEOEkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 00:40:31 -0400
Received: from ozlabs.org ([203.10.76.45]:34687 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbYEOEkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 00:40:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18475.48822.311219.341385@cargo.ozlabs.ibm.com>
Date: Thu, 15 May 2008 14:40:22 +1000
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, pq@iki.fi,
       proski@gnu.org, sandmann@redhat.com, a.p.zijlstra@chello.nl,
       linuxppc-dev@ozlabs.org, benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] ftrace ported to PPC
In-Reply-To: <20080515034942.109223655@goodmis.org>
References: <20080515034942.109223655@goodmis.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> The following two patches ports ftrace to PowerPC. I tested this on
> both my PPC64 box as well as my 32bit PowerBook G4.

Very cool!  Thanks.

> This applies to the latest sched-devel (with some extra hacks to get that
> to boot on PPC).
> 
> This also depends on the CFLAGS_REMOVE_foo.o patches I sent earlier.

Ingo, when do you intend to send the ftrace stuff to Linus?  In the
next merge window?

Paul.
