Return-Path: <linux-kernel-owner+w=401wt.eu-S1762747AbZFPVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762747AbZFPVnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZFPVnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:43:07 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60254 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbZFPVnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:43:07 -0400
To: hpa@zytor.com
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [x86] Build error at arch/x86/boot/bioscall.S
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp>
	<20090616081445.GB6270@cr0.nay.redhat.com>
	<4A37B703.3060409@zytor.com>
In-Reply-To: <4A37B703.3060409@zytor.com>
Message-Id: <200906170643.IFD39026.MLOtQFOFHSFVOJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 17 Jun 2009 06:43:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Does changing .code16 to .code16gcc work for you?
Yes, that works.

Thank you.
