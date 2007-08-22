Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbXHVKZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbXHVKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbXHVKZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:25:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbXHVKZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:25:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
X-Fcc: ~/Mail/linus
Cc: akpm@osdl.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1: cannot stat `vdso.so.dbg'
In-Reply-To: Alexey Dobriyan's message of  Wednesday, 22 August 2007 14:15:29 +0400 <20070822101529.GE7228@localhost.sw.ru>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20070822102434.D82B84D04B2@magilla.localdomain>
Date: Wed, 22 Aug 2007 03:24:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That is fixed by the later version of the vdso-install patches I sent later.
I thought Andrew had already incorporated the fixed versions.


Thanks,
Roland
