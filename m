Return-Path: <linux-kernel-owner+w=401wt.eu-S1763892AbYEFQRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763892AbYEFQRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYEFQRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:17:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbYEFQRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:17:13 -0400
Date: Tue, 6 May 2008 09:16:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Hugh Dickins <hugh@veritas.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
In-Reply-To: <20080506151529.GA6321@elte.hu>
Message-ID: <alpine.LFD.1.10.0805060916130.32269@woody.linux-foundation.org>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <20080506150432.GA31075@elte.hu> <alpine.LFD.1.10.0805060807520.32269@woody.linux-foundation.org>
 <20080506151529.GA6321@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Ingo Molnar wrote:
> 
> yeah, indeed, sorry about that. Will sort this type mixing out today.

Just take Hugh's patch. It's correct. Your code wasn't. Just admit it, and 
let others fix things.

			Linus
