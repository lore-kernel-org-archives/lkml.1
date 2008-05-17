Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbYEQBfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbYEQBfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 21:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYEQBfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 21:35:02 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:57619 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbYEQBfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 21:35:00 -0400
To: akataria@vmware.com
Cc: devzero@web.de, linux-kernel@vger.kernel.org, dhecht@vmware.com
Subject: Re: Kernel hangs in SMP + VMware environment.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>
	<200805150611.m4F6Bv4J046219@www262.sakura.ne.jp>
	<D3C12B2AD838B44DA9D6B2CA334246D00D8F38DA60@PA-EXMBX04.vmware.com>
	<200805162148.AAJ21381.QOSMOFFFLHOVJt@I-love.SAKURA.ne.jp>
	<D3C12B2AD838B44DA9D6B2CA334246D00DC43DE5E6@PA-EXMBX04.vmware.com>
In-Reply-To: <D3C12B2AD838B44DA9D6B2CA334246D00DC43DE5E6@PA-EXMBX04.vmware.com>
Message-Id: <200805171034.CJC04647.HOFMOJVFQFOLtS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 17 May 2008 10:34:57 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> > I'm not sure, but this problem might exist in all kernels since 2.6.18 , for
> > I can find clocksource= parameter in Documentation/kernel-parameters.txt .
> >
> Sorry, but I dont understand what you are pointing to, the 2.6.18 kernel does
> have clocksource parameter.
> And you are correct this could be a problem with all the kernels which are
> using clocksource.
>
> If you are able to reproduce this with any of the kernels with the patch applied
> Please let me know.
I'm not saying "I was able to reproduce this problem after applying your patch".
I'm saying "All kernels since 2.6.18 might have this problem, and we need to apply
your patch to all kernels since 2.6.18 if they actually have this problem".
> > 
> > The Ctrl-C didn't work, the Alt-F? didn't work, the Ctrl-Alt-Del didn't work.
> > I had no time to reproduce it, so I'm not sure it has actually hanged up.
> > 

Thanks.
