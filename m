Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYCBIVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYCBIVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 03:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYCBIVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 03:21:46 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:63769 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYCBIVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 03:21:46 -0500
To: bunk@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: How do arch/ppc and arch/powerpc differ?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200803021602.EGJ81261.OJtOFVQFFHOSLM@I-love.SAKURA.ne.jp>
	<20080302080939.GG25835@cs181133002.pp.htv.fi>
In-Reply-To: <20080302080939.GG25835@cs181133002.pp.htv.fi>
Message-Id: <200803021721.CCG18204.OOFStFHOQMFVJL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 2 Mar 2008 17:21:40 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> > Which keyword ("ppc" or "powerpc") do I need to set for ARCH
> > to do cross-compilation checking?
> 
> powerpc
> 
I see.

I'm doing "crossdev -t ia64" now.
More architectures to test (e.g. non-MMU arch) before submitting?

Thank you.
