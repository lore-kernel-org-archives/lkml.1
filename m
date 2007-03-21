Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbXCUWxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbXCUWxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXCUWxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:53:36 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbXCUWxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:53:36 -0400
Date: Wed, 21 Mar 2007 15:53:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] Blackfin: architecture update patch
Message-Id: <20070321155324.a7d2d75a.akpm@linux-foundation.org>
In-Reply-To: <1174472363.5648.58.camel@roc-desktop>
References: <1174472363.5648.58.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 18:19:23 +0800
"Wu, Bryan" <bryan.wu@analog.com> wrote:

> 1) Some issues are fixed according to LKML patch review.
> 2) Remove not supported BF535 code
> 3) Fixed some bugs from blackfin.uclinux.org SVN update
> Here is the updated patch for 2.6.21-rc4-mm1

1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/cplbinit.h.rej
1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/mach-bf535/bf535.h.rej
1 out of 1 hunk FAILED -- saving rejects to file include/asm-blackfin/scatterlist.h.rej

This seems to be against a kernel which did not include
blackfin-arch-balance-parenthesis-in-macros.patch.  But 2.6.21-rc4-mm1 did
include blackfin-arch-balance-parenthesis-in-macros.patch, so I'm not sure
what is going on here.


