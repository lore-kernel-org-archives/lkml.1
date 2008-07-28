Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbYG1BJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbYG1BJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 21:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYG1BJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 21:09:05 -0400
Received: from namei.org ([69.55.235.186]:34596 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752594AbYG1BJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 21:09:04 -0400
Date: Mon, 28 Jul 2008 11:07:40 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, ppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] powerpc/ibmveth: fix multiple errors with dma_mapping_error
 conversion
In-Reply-To: <20080728103253.5256e6c0.sfr@canb.auug.org.au>
Message-ID: <Xine.LNX.4.64.0807281101310.19550@us.intercode.com.au>
References: <20080728021424.40cf66bc.sfr@canb.auug.org.au>
 <20080727122414.cac4e336.akpm@linux-foundation.org>
 <20080728103253.5256e6c0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008, Stephen Rothwell wrote:

> I hope that we all can discuss procedures for API changes at the Kernel
> Summit ...

"all" as in, whoever was invited (the only transparent aspect of was a 
silly count of # of commits for the initial shortlist), or was on the 
committee, or bought seats via sponsorship.



- James (co- maintainer/author of several kernel subsystems over 8+ years 
and apparently not invited, because ?)


-- 
James Morris
<jmorris@namei.org>
