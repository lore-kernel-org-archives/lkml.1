Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbZDSM7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbZDSM7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 08:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbZDSM7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 08:59:10 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:33096 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZDSM7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 08:59:09 -0400
Date: Sun, 19 Apr 2009 13:41:15 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: mips build failure
Message-ID: <20090419114115.GA28982@linux-mips.org>
References: <20090419172436.6d0e741a.sfr@canb.auug.org.au> <1240126361.3423.5.camel@falcon> <20090419081641.GA23906@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419081641.GA23906@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 10:16:41AM +0200, Ingo Molnar wrote:

> > in reality, there is a previous email sent by Ralf for it:
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0904.2/01152.html
> 
> Yes, that looks like the right kind of fix.
> 
> Ralf, will you push that fix upstream, or should i do it?

Linus is cc'ed on that patch so expect this patch to show up in his tree
right after the weekend.

  Ralf
