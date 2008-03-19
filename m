Return-Path: <linux-kernel-owner+w=401wt.eu-S965794AbYCSXEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965794AbYCSXEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937408AbYCSVa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:30:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36657
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932466AbYCSVaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:30:24 -0400
Date: Wed, 19 Mar 2008 14:30:37 -0700 (PDT)
Message-Id: <20080319.143037.180042261.davem@davemloft.net>
To: roland@redhat.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, sparclinux@vger.kernel.org, paulus@samba.org,
       linuxppc-dev@ozlabs.org, rth@twiddle.net, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 5/8] sparc64 ptrace: forced_successful_syscall_return()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080319212001.2DB8526F995@magilla.localdomain>
References: <20080319211714.8B14226F995@magilla.localdomain>
	<20080319212001.2DB8526F995@magilla.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Wed, 19 Mar 2008 14:20:01 -0700 (PDT)

> Define the forced_successful_syscall_return() macro to
> pair with our force_successful_syscall_return() definition.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
