Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZFPFso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZFPFso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZFPFsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:48:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50552 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZFPFsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:48:37 -0400
Subject: Re: linux-next: manual merge of the tip tree with the slab tree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <20090616154652.b8adcb9d.sfr@canb.auug.org.au>
References: <20090616154652.b8adcb9d.sfr@canb.auug.org.au>
Date: Tue, 16 Jun 2009 08:48:38 +0300
Message-Id: <1245131318.3415.1.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 15:46 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in mm/slub.c
> between commit 964cf35c88f93b4927dbc4e950dfa4d880c7f9d1 ("SLUB: Fix early
> boot GFP_DMA allocations") from the slab tree and commit
> 18fd427debcf37c06917b55295df682fd05fee76 ("slub: add hooks for
> kmemcheck") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good! Thanks.

