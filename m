Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbXIYPw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbXIYPw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXIYPwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:52:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755636AbXIYPwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:52:49 -0400
Date: Tue, 25 Sep 2007 08:46:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.23-rc8-mm1
Message-Id: <20070925084657.8be44dc1.akpm@linux-foundation.org>
In-Reply-To: <46F8E563.8030105@linux.vnet.ibm.com>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
	<46F8E563.8030105@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 16:09:31 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm1/
> 
> Hi Andrew,
> 
> The build error reported at http://lkml.org/lkml/2007/9/20/210 for the
> drivers/ata/pata_scc.c is seen in both 2.6.23-rc7-mm1 and 2.6.23-rc8-mm1.

The followup to that report wasn't clear to me and I was hoping that Alan
could help find the final fix.

> The patch proposed for this build error at http://lkml.org/lkml/2007/9/21/557
> is not seen in the latest 2.6.23-rc8-mm1 patch's.

Alan didn't comment on that one.  afacit it is needed in Jeff's
git-libata-all tree.  I'll merge it and see what happens.

