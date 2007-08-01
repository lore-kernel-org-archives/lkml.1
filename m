Return-Path: <linux-kernel-owner+w=401wt.eu-S932977AbXHAPwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977AbXHAPwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbXHAPwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:52:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:62464 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbXHAPwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:52:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nS7zy+GZF0bKB/vi6yrpxxHm/GHjLQqVIsiRC+sy2ppaVbWg323/6OP2ahxlmPkfnlSUAi1R+1TUQ2GlH4rCmAeHuDqOnZCOzl0YnOJz0aVRpFWzJ0NMmHQ0mx5116PrVX+0df+TF0mDAEGms7a93h/4GAl/HVes782Szu70JFc=
Message-ID: <29495f1d0708010852p7a53a0a8ra5e8155a3bf12965@mail.gmail.com>
Date: Wed, 1 Aug 2007 08:52:35 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Zan Lynx" <zlynx@acm.org>
Subject: Re: 2.6.22-rc1-mm1 huge pages VM freeze (maybe?)
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1185919297.6981.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185918261.6981.13.camel@localhost>
	 <20070731150245.5932b763.randy.dunlap@oracle.com>
	 <1185919297.6981.16.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Zan Lynx <zlynx@acm.org> wrote:
> On Tue, 2007-07-31 at 15:02 -0700, Randy Dunlap wrote:
> > On Tue, 31 Jul 2007 15:44:21 -0600 Zan Lynx wrote:
> >
> > > I was playing with huge pages and libhugetlbfs.  Small programs like
> > > "ls" work fine.  I tried running Evolution through libhugetlbfs and the
> > > system slowly stops running.  One interesting thing is the "ps" command,
> > > it gets stuck like this:
> >
> > Do you mean 2.6.22-rc1-mm1 or 2.6.23-rc1-mm1?
>
> D'oh!  I mean 2.6.23-rc1-mm1, the 22 was a typo.  Cut & paste to be
> sure:
> Linux zephyr 2.6.23-rc1-mm1 #1 SMP PREEMPT Wed Jul 25 17:33:04 MDT 2007
> x86_64 AMD Athlon(tm) 64 Processor 3400+ AuthenticAMD GNU/Linux

Just to confirm, still happens with -mm2?

Thanks,
Nish
