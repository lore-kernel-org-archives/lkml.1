Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYDXGfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYDXGfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 02:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYDXGfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 02:35:07 -0400
Received: from ozlabs.org ([203.10.76.45]:52724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYDXGfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 02:35:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18448.10755.660560.776824@cargo.ozlabs.ibm.com>
Date: Thu, 24 Apr 2008 16:34:43 +1000
From: Paul Mackerras <paulus@samba.org>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] powerpc TLF_RESTORE_SIGMASK
In-Reply-To: <20080423063753.C2088270381@magilla.localdomain>
References: <20080403210842.6C88C26F98D@magilla.localdomain>
	<18446.50037.964682.539009@cargo.ozlabs.ibm.com>
	<20080423063753.C2088270381@magilla.localdomain>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath writes:

> Indeed so.  Here's a replacement patch.

Oh, and could you please also fix the occurrence of
TIF_RESTORE_SIGMASK in arch/ppc/kernel/entry.S when this stuff goes
in?

Thanks,
Paul.
