Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab0CJMCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:02:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48585 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751090Ab0CJMCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:02:02 -0500
Date: Wed, 10 Mar 2010 12:01:56 +0000
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: MFD_WM831X should depend on GENERIC_HARDIRQS
Message-ID: <20100310120155.GO24422@rakim.wolfsonmicro.main>
References: <alpine.DEB.2.00.0912152157330.27772@ayla.of.borg>
 <20091215221357.GA26024@opensource.wolfsonmicro.com>
 <10f740e81003091113j5b55edf7r7eec8728bcc87821@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10f740e81003091113j5b55edf7r7eec8728bcc87821@mail.gmail.com>
Grom: Mark Brown <broonie@opensource.wolfsonmicro.com>
X-Cookie: Your fault -- core dumped
User-Agent: Mutt/1.5.20 (2009-06-14)
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 08:13:56PM +0100, Geert Uytterhoeven wrote:

> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> This patch still hasn't made it. In addition, 3 more drivers started
> to show the same problems
> on architectures that don't use genirq yet, so I updated it.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

TBH I'm surprised there's architectures that haven't implemented genirq
yet.
