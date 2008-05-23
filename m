Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbYEWHD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbYEWHD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYEWHDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:03:19 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65052 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbYEWHDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:03:18 -0400
Message-Id: <200805230702.m4N724po044435@www262.sakura.ne.jp>
Subject: Re: [git patch] vfs: permission API cleanup (v2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       penguin-kernel@i-love.sakura.ne.jp
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 May 2008 16:02:04 +0900
References: <E1JzDzC-0008MT-Hb@pomaz-ex.szeredi.hu> <200805230400.m4N40f6W010852@www262.sakura.ne.jp> <E1JzQwy-0001Dp-E8@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JzQwy-0001Dp-E8@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Miklos Szeredi wrote:
> 
> I really appreciate your testing on this tree.
> 

Never mind.

AppArmor and TOMOYO Linux are waiting for your cleanups
to be merged into mainline so that they can propose inserting
new LSM hooks within path_*() functions.

Thanks.
