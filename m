Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbYBTIAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbYBTIAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYBTH7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:59:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYBTH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:59:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Shi Weihua <shiwh@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
	check
In-Reply-To: Harvey Harrison's message of  Tuesday, 19 February 2008 21:54:07 -0800 <1203486847.23194.4.camel@brick>
References: <47B95C4D.6080000@cn.fujitsu.com>
	<20080218134720.GA28851@elte.hu>
	<47BA299A.3040207@cn.fujitsu.com>
	<20080219185009.122ED2701BA@magilla.localdomain>
	<47BB7922.1010400@cn.fujitsu.com>
	<20080220011822.C510B2701BA@magilla.localdomain>
	<47BB83E2.1030504@cn.fujitsu.com>
	<20080220014419.B85D02701BA@magilla.localdomain>
	<47BB8F05.3050001@cn.fujitsu.com>
	<20080220024928.0EE172701BA@magilla.localdomain>
	<1203486847.23194.4.camel@brick>
Emacs: there's a reason it comes with a built-in psychotherapist.
Message-Id: <20080220075918.B4FE72701BA@magilla.localdomain>
Date: Tue, 19 Feb 2008 23:59:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've been looking at that, at the same time a bunch of ia32/signal.c
> looks like it can go away.

Yes, I meant the 3 into 1 unification.


Thanks,
Roland
