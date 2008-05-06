Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYEFGHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYEFGHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbYEFGHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:07:20 -0400
Received: from smtp.ono.com ([62.42.230.12]:44168 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758940AbYEFGHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:07:16 -0400
Date: Tue, 6 May 2008 08:07:12 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Scheduling problems ? [ Was: Linux 2.6.26-rc1 ]
Message-ID: <20080506080712.5aab6d97@werewolf.home>
In-Reply-To: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.4.0cvs16 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I have installed this kernel, and it behaves a bit strange.

If I launch a movie under totem, it plays nicely (no HD, just 512x384).
If then I start deluge with some torrents downloading, the video begins to
loose frames and jump, like loosing 1 or 2 frames per second.
There is not much bandwidth used, just 15-20 Kb.

I have tried the same copying a kernel source tree and the video plays fine.
So can it be something network related, os network+io to disk ?

No group scheduling, 1000Hz, fully preemptive kernel.
If you smell something and need my .config I will post it.

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
