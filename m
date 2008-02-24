Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYBXDSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYBXDSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 22:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbYBXDR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 22:17:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbYBXDR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 22:17:57 -0500
Date: Sat, 23 Feb 2008 22:17:50 -0500
From: Rik van Riel <riel@redhat.com>
To: "J.C. Pizarro" <jcpiza@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Please, put 64-bit counter per task and incr.by.one each ctxt
 switch.
Message-ID: <20080223221750.429cf0d9@bree.surriel.com>
In-Reply-To: <998d0e4a0802231908h37978d07wa5379d5c01b2c2ee@mail.gmail.com>
References: <998d0e4a0802231908h37978d07wa5379d5c01b2c2ee@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 04:08:38 +0100
"J.C. Pizarro" <jcpiza@gmail.com> wrote:

> We will need 64 bit counters of the slow context switches,
>   one counter for each new created task (e.g. u64 ctxt_switch_counts;)

Please send a patch ...

> I will explain your later why of it.

... and explain exactly why the kernel needs this extra code.

Asking somebody else to add functionality (or is it bloat?  we really
cannot tell) to the kernel for you, and not even explaining why is
not going to convince anyone.

For more hints on how to get functionality into the Linux kernel,
please read:

http://kernelnewbies.org/UpstreamMerge

-- 
All rights reversed.
