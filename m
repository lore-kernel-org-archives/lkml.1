Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbYELHhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbYELHhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbYELHh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:37:29 -0400
Received: from www.tglx.de ([62.245.132.106]:43031 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbYELHh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:37:28 -0400
Date: Mon, 12 May 2008 09:37:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [Bug #10672] 2.6.26-rc1 regression: ISA DMA broken (bisected)
In-Reply-To: <88YBFoyd1CN.A.VWG.hv1JIB@chimera>
Message-ID: <alpine.LFD.1.10.0805120936290.3514@apollo.tec.linutronix.de>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.VWG.hv1JIB@chimera>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10672
> Subject		: 2.6.26-rc1 regression: ISA DMA broken (bisected)
> Submitter	: Rene Herman <rene.herman@keyaccess.nl>
> Date		: 2008-05-09 1:37 (3 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121029711005560&amp;w=4
> Handled-By	: Takashi Iwai <tiwai@suse.de>
> Patch		: http://marc.info/?l=linux-kernel&amp;m=121032355203154&amp;w=4

Patch is queued for the next pull.

Thanks,
	tglx
