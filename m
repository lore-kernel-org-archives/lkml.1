Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752258AbYLQWmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbYLQWmI (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYLQWlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:41:42 -0500
Received: from ozlabs.org ([203.10.76.45]:46756 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYLQWll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:41:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18761.32798.327649.628188@cargo.ozlabs.ibm.com>
Date: Thu, 18 Dec 2008 09:41:34 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: Please pull from 'merge' for 2.6.28
In-Reply-To: <Pine.LNX.4.64.0812171006580.12026@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0812171006580.12026@blarg.am.freescale.net>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala writes:

> The following changes since commit 23e0e8afafd9ac065d81506524adf3339584044b:
>   Arnd Bergmann (1):
>         powerpc/cell/axon-msi: Fix MSI after kexec
> 
> are available in the git repository at:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git merge

Linus, please pull Kumar's tree directly, since I have no other
commits needing to go in 2.6.28 at this stage.

Thanks,
Paul.
