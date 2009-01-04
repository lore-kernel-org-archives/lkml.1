Return-Path: <linux-kernel-owner+w=401wt.eu-S1751641AbZADL0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbZADL0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZADLZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:25:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35298 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbZADLZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:25:54 -0500
Date: Sun, 4 Jan 2009 12:25:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Huang Weiyi <weiyi.huang@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: swiotlb: remove duplicated #include
Message-ID: <20090104112541.GA25434@elte.hu>
References: <20090104110951.C9AB.WEIYI.HUANG@gmail.com> <alpine.LNX.2.00.0901041057400.26359@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0901041057400.26359@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesper Juhl <jj@chaosbits.net> wrote:

> On Sun, 4 Jan 2009, Huang Weiyi wrote:
> 
> > Removed duplicated #include in lib/swiotlb.c.
> > 
> 
> This is identical to a patch I already submitted - 
> http://lkml.org/lkml/2009/1/2/360 - but I don't know if that one has been 
> merged anywhere yet.

i've applied yours to tip/core/urgent, thanks Jesper!

	Ingo
