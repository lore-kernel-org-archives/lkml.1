Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbXFTVmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbXFTVmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbXFTVmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:42:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbXFTVmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:42:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
X-Fcc: ~/Mail/linus
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, ak@suse.de, hch@infradead.org,
       devel@openvz.org
Subject: Re: [PATCH -mm 2/2] x86_64: semi-rewrite of PTRACE_PEEKUSR, PTRACE_POKEUSR
In-Reply-To: Alexey Dobriyan's message of  Wednesday, 20 June 2007 19:08:44 +0400 <20070620150844.GC6663@localhost.sw.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070620214148.51AE34D05DC@magilla.localdomain>
Date: Wed, 20 Jun 2007 14:41:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What's the purpose of the change?
