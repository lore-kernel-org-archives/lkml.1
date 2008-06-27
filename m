Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbYF0Mes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbYF0Mes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759562AbYF0Mef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:34:35 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61193 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534AbYF0Mee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:34:34 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel hangs in SMP + VMware environment.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200805150611.m4F6Bv4J046219@www262.sakura.ne.jp>
	<D3C12B2AD838B44DA9D6B2CA334246D00D8F38DA60@PA-EXMBX04.vmware.com>
	<200805162148.AAJ21381.QOSMOFFFLHOVJt@I-love.SAKURA.ne.jp>
	<D3C12B2AD838B44DA9D6B2CA334246D00DC43DE5E6@PA-EXMBX04.vmware.com>
	<200805171034.CJC04647.HOFMOJVFQFOLtS@I-love.SAKURA.ne.jp>
In-Reply-To: <200805171034.CJC04647.HOFMOJVFQFOLtS@I-love.SAKURA.ne.jp>
Message-Id: <200806272134.DED65160.OJMtOFLFOFQVSH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 27 Jun 2008 21:34:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> I'm saying "All kernels since 2.6.18 might have this problem, and we need to apply
> your patch to all kernels since 2.6.18 if they actually have this problem".

Today, I found that the CentOS 5.2's 2.6.18-92.1.6.el5 kernel has the patch applied.
So, this problem existed in all kernels since 2.6.18, right?

Does this problem happen when used in non-virtualized (i.e. native) environment?

Regards.
