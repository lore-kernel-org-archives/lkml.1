Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbXLQNQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbXLQNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXLQNQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:16:47 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:61030 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbXLQNQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:16:46 -0500
To: a1426z@gawab.com, indan@nul.nu
Cc: david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <47650A4C.4000708@davidnewall.com>
	<200712170040.lBH0e6sf099887@www262.sakura.ne.jp>
	<54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
	<200712171605.31084.a1426z@gawab.com>
In-Reply-To: <200712171605.31084.a1426z@gawab.com>
Message-Id: <200712172216.HDI95882.HVQtOFFLMJOSOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 17 Dec 2007 22:16:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Al Boldi wrote:
> I think the answer is obvious:  Tetsuo wants to add functionality that the
> MACs are missing.  So, instead of adding this functionality per MAC, he
> proposes to add it as ground work, to be combined with any MAC.
Yes, that's right.

This filesystem is designed to be used with TOMOYO Linux,
but this filesystem can be used with other MAC implementations too.

Thank you.
