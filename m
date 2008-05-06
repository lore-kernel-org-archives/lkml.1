Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYEFLft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYEFLft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYEFLfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:35:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49490 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYEFLfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:35:37 -0400
Date: Tue, 6 May 2008 13:35:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix vdso_enabled type on x86_64
Message-ID: <20080506113528.GA32591@elte.hu>
References: <871w4fst5c.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871w4fst5c.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> This fixes type of "vdso_enabled" on X86_64 to match extern in 
> asm/elf.h.

applied, thanks.

	Ingo
