Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbXLXBxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbXLXBxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 20:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXLXBxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 20:53:16 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:62029 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbXLXBxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 20:53:16 -0500
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.24-rc6-mm1] BUG() at check_irqs_on() in fs/buffer.c .
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712232212.GII90159.tFFVSOLFJHQOOM@I-love.SAKURA.ne.jp>
	<20071223151656.GA18738@elte.hu>
In-Reply-To: <20071223151656.GA18738@elte.hu>
Message-Id: <200712241053.ADJ52655.FVMHLOFJOtQOSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 24 Dec 2007 10:53:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Ingo Molnar wrote:
> does the patch below help?

Yes, it solved this bug.

Thank you.
