Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYG2N7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYG2N7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYG2N7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:59:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:41598 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbYG2N7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:59:11 -0400
Date: Tue, 29 Jul 2008 06:58:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: NETDEV WATCHDOG: wifi0: transmit timed out
Message-ID: <20080729065859.2bcc65ed@infradead.org>
In-Reply-To: <20080729215315.5a505fe7.komurojun-mbn@nifty.com>
References: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
	<20080729215315.5a505fe7.komurojun-mbn@nifty.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 21:53:15 +0900
Komuro <komurojun-mbn@nifty.com> wrote:

> Hi,
> 
> Please try to comment out the "WARN_ON_ONCE"
> at net/sched/sched_generic.c.
> 

"I have a hardware failure so I'll comment out the message that says
so, and then I won't have a failure". Yeah that'll work well.
