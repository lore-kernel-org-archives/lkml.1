Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbXELMOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbXELMOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 08:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbXELMOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 08:14:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38606 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755829AbXELMOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 08:14:32 -0400
Date: Sat, 12 May 2007 13:15:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Rene Herman <rene.herman@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, rpjday@mindspring.com, marcel@holtmann.org,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
Message-ID: <20070512131530.5258d588@the-village.bc.nu>
In-Reply-To: <20070512071455.GH7984@stusta.de>
References: <4643BDF2.9030105@gmail.com>
	<20070511114605.4c2698ec@the-village.bc.nu>
	<alpine.DEB.0.98.0705110740420.12363@sigma.j-a-k-j.com>
	<20070511211823.GG7984@stusta.de>
	<20070511223500.01fe6596@the-village.bc.nu>
	<20070512071455.GH7984@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'd prefer not. I get reports from people about drivers that got "lost"
> > by vendors, regularly. Nor am I pointing fingers at specific vendors here,
> > last month I sorted out a two year old "lost in Red Hat Bugzilla" kernel
> > bug for example.
> 
> How many maintainers want to get bug reports against the kernel 2.6.9 
> shipped with RHEL 4?

The enterprise kernels which tend to be the ones with the long lag also
have a userbase with support contracts so tend not to consider l/k as
their first support stop anyway.

