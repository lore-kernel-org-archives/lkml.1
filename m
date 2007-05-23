Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbXEWDlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbXEWDlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 23:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbXEWDlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 23:41:24 -0400
Received: from www.osadl.org ([213.239.205.134]:54539 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755580AbXEWDlX (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 23:41:23 -0400
Subject: Re: [PATCH] 2.6.21-rt6
From: Thomas Gleixner <tglx@linutronix.de>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: LKML <Linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1179876979.25500.54.camel@sx.thebigcorporation.com>
References: <1179874795.25500.40.camel@sx.thebigcorporation.com>
	 <1179876979.25500.54.camel@sx.thebigcorporation.com>
Content-Type: text/plain
Date: Wed, 23 May 2007 05:41:21 +0200
Message-Id: <1179891681.12708.138.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 16:36 -0700, Sven-Thorsten Dietrich wrote:
> On Tue, 2007-05-22 at 15:59 -0700, Sven-Thorsten Dietrich wrote:
> > Add 
> <correct>
> > header and export for rt_write_trylock_irqsave.
> 
> Disregard the last patch, flags parameter was missing in the header.

Signed-off-by is missing as well as a useful subject line :)

Applied.

Thanks,

	tglx


