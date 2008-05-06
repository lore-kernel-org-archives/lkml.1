Return-Path: <linux-kernel-owner+w=401wt.eu-S1765707AbYEFSkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765707AbYEFSkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbYEFSkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:40:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765342AbYEFSkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:40:04 -0400
Date: Tue, 6 May 2008 11:39:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
In-Reply-To: <Pine.LNX.4.64.0805061435510.32567@blonde.site>
Message-ID: <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Hugh Dickins wrote:
> 
> Not-yet-Signed-off-by: Hugh Dickins <hugh@veritas.com>

Ok, please let me know when there is a final patch I can apply,

		Linus
