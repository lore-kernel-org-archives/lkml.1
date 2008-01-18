Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYARDU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYARDU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 22:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYARDUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 22:20:15 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62787 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYARDUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 22:20:13 -0500
Message-Id: <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Zan Lynx <zlynx@acm.org>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2008 12:19:56 +0900
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp> <20080117181935.02294863.akpm@linux-foundation.org>
In-Reply-To: <20080117181935.02294863.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> I'd be suspecting git-sched, so in lieu of a full bisection search it would
> be great if one of you could apply
> http://userweb.kernel.org/~akpm/git-sched.patch to 2.6.24-rc8 and see if it
> fails in the same way.
Too bad. It didn't fail.

Regards.
