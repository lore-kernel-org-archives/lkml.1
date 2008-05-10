Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbYEJNZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbYEJNZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 09:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYEJNYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 09:24:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60902 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbYEJNYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 09:24:51 -0400
Date: Sat, 10 May 2008 08:22:46 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: ppc compile failure (__flush_icache_range etc undeclared)
Message-ID: <20080510082246.0ce82981@zod.rchland.ibm.com>
In-Reply-To: <Pine.SOC.4.64.0805101448580.8450@math.ut.ee>
References: <Pine.SOC.4.64.0805101448580.8450@math.ut.ee>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2008 14:51:27 +0300 (EEST)
Meelis Roos <mroos@linux.ee> wrote:

> Tried 2.6.26-rc1+git on ppc (arch/ppc, PReP subarch) and got this:

Segher sent patches to fix this earlier this week.  You can find them
here:

http://patchwork.ozlabs.org/linuxppc/patch?id=18348
http://patchwork.ozlabs.org/linuxppc/patch?id=18346
http://patchwork.ozlabs.org/linuxppc/patch?id=18347

People keep breaking arch/ppc and it seems there's little motivation to
fix it since it's going away in a month.

josh
