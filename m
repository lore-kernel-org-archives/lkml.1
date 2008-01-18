Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYARJjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYARJjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbYARJjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:39:06 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61935 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbYARJjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:39:04 -0500
Message-Id: <200801180938.m0I9cjvA065103@www262.sakura.ne.jp>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Zan Lynx <zlynx@acm.org>, Dave Young <hidave.darkstar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2008 18:38:45 +0900
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp> <20080117181935.02294863.akpm@linux-foundation.org> <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp> <20080117204247.5318e500.akpm@linux-foundation.org> <200801180640.m0I6enPI029212@www262.sakura.ne.jp> <a8e1da0801172259s3377895dwb0b2ca1dd781d11b@mail.gmail.com> <20080118091810.GG24337@elte.hu>
In-Reply-To: <20080118091810.GG24337@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Ingo Molnar wrote:
> is the patch below already in -rc8-mm1? hmm ... it appears it's not. 
> Could you give it a try?

This patch solved this bug.

Thank you.
