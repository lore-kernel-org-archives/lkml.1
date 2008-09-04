Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYIDXx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYIDXx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYIDXxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:53:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbYIDXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:53:17 -0400
Date: Thu, 4 Sep 2008 16:53:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: linux-next: Tree for September 4
Message-Id: <20080904165309.b5fd9214.akpm@linux-foundation.org>
In-Reply-To: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 19:36:06 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

sparc64 `make headers_check':

make[1]: *** No rule to make target `/usr/src/devel/arch/sparc/include/asm/statfs_32.h', needed by `/usr/src/devel/usr/include/asm/.install'.  Stop.
