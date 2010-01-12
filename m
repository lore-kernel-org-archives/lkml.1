Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955Ab0ALOzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0ALOzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288Ab0ALOzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:55:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0ALOzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:55:43 -0500
Subject: Re: Futex hang/lockup problem in 2.6.30+ on AMD64
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Athan <linux_kernel_aathan@memeplex.com>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100112145213.GB3925@hack>
References: <4B4C3E4F.9060001@memeplex.com>  <20100112145213.GB3925@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 15:55:27 +0100
Message-ID: <1263308127.4244.142.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 22:52 +0800, Américo Wang wrote:

> > $ uname -a
> > Linux UK22 2.6.30-2-amd64 #1 SMP Fri Sep 25 22:16:56 UTC 2009 x86_64  
> > GNU/Linux

Does a recent kernel work?

