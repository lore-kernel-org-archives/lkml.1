Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbYGPIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbYGPIqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYGPIqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:46:08 -0400
Received: from ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk ([217.169.26.28]:53468
	"EHLO ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbYGPIqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:46:07 -0400
Date: Wed, 16 Jul 2008 09:46:03 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [MIPS] add missing prototypes to asm/page.h
Message-ID: <20080716084603.GC22957@linux-mips.org>
References: <1216141052-28005-1-git-send-email-dmitri.vorobiev@movial.fi> <1216141052-28005-4-git-send-email-dmitri.vorobiev@movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216141052-28005-4-git-send-email-dmitri.vorobiev@movial.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 07:57:32PM +0300, Dmitri Vorobiev wrote:

> This patch fixes the following sparse warnings:
> 
> >>>>>>>>>>>>>>>>>>
> arch/mips/mm/page.c:284:16: warning: symbol
> 'build_clear_page' was not declared. Should it be static?
> 
> arch/mips/mm/page.c:426:16: warning: symbol 'build_copy_page'
> was not declared. Should it be static?
> >>>>>>>>>>>>>>>>>>
> 
> The fix is to add appropriate prototypes to the header
> include/asm-mips/page.h.

Same comment as for 2/3 applies.  Patch applied.  Thanks,

  Ralf
