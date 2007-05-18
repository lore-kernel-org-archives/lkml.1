Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbXERHs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbXERHs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbXERHsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:48:21 -0400
Received: from www.osadl.org ([213.239.205.134]:48251 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755121AbXERHsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:48:20 -0400
Subject: Re: v2.6.21-rt3
From: Thomas Gleixner <tglx@linutronix.de>
To: emin ak <eminak71@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <2cf1ee820705180039l1d72005fq2169f8fa36e12377@mail.gmail.com>
References: <20070517194143.GA25394@elte.hu>
	 <2cf1ee820705180039l1d72005fq2169f8fa36e12377@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 09:53:24 +0200
Message-Id: <1179474804.12981.57.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 10:39 +0300, emin ak wrote:
> Hi,
> I have tried to compile -rt3 patch for ppc (mpc8540ads) and it failed
> with undefined referance errors on ppc/kernel/asm-offsets.c. Here is
> the compiler outputs:

arch/ppc is known to be broken. Does it even compile on 2.6.21 vanilla ?

	tglx


