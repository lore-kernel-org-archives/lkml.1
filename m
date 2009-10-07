Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZJGNbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZJGNbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZJGNbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:31:35 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:50670 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbZJGNbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:31:34 -0400
To: pavel@ucw.cz
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #16 00/25] Starting TOMOYO 2.3
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp>
	<20091006093922.GB1363@ucw.cz>
	<200910070409.n9749OQ1092174@www262.sakura.ne.jp>
	<20091007073806.GC31245@elf.ucw.cz>
In-Reply-To: <20091007073806.GC31245@elf.ucw.cz>
Message-Id: <200910072230.JGE82381.OFHStFOQLJMVFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 7 Oct 2009 22:30:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> You are expected to submit diffs in smaller steps, not "here it is,
> totally rewritten, take it or leave it".
I see. I'll try to break this patchset into smaller steps.

Your comment ( http://lkml.org/lkml/2009/5/1/47 ) was the trigger for not only
garbage collector but also many usability and feature enhancements for TOMOYO.
Thank you. :-)
