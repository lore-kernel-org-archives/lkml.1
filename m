Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYLaCoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYLaCoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 21:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYLaCo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:44:26 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55879 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbYLaCoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:44:25 -0500
To: frederik.deweerdt@xprog.eu
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [2.6.28] NULL pointer dereference at get_stats()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200812302153.ECH86976.MFLOQFJHtSOOFV@I-love.SAKURA.ne.jp>
	<20081230155215.GA31531@gambetta>
	<200812310201.GJH43235.OFFLHFMStOJVOQ@I-love.SAKURA.ne.jp>
	<20081230213727.GA2001@gambetta>
	<200812311125.HBI34373.MFVOtFOSJLOHFQ@I-love.SAKURA.ne.jp>
In-Reply-To: <200812311125.HBI34373.MFVOtFOSJLOHFQ@I-love.SAKURA.ne.jp>
Message-Id: <200812311144.EBG57300.VFFOFSOMOJHQLt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 31 Dec 2008 11:44:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> That patch breaks driver initialization code

Oh, please wait. It may be my operational mistake.
The content of /init in initrd-2.6.28.img differs.
