Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXKPSWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXKPSWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXKPSWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:22:41 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:62292 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbXKPSWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:22:39 -0500
To: yoshfuji@linux-ipv6.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp
Subject: Re: [TOMOYO #5 11/18] Network access control functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	<20071116173527.282964575@I-love.SAKURA.ne.jp>
	<20071117.025708.29947074.yoshfuji@linux-ipv6.org>
In-Reply-To: <20071117.025708.29947074.yoshfuji@linux-ipv6.org>
Message-Id: <200711170322.HFH78609.FMFFJHOLtVOOQS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 17 Nov 2007 03:22:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki wrote:
> I think you can use in6_pton() here.
> in4_pton().
I see. I'll try it later.

Thanks.

