Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYLHP1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYLHP1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYLHP0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:26:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbYLHP0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:26:53 -0500
Date: Mon, 8 Dec 2008 07:25:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oliver Hartkopp <oliver@hartkopp.net>
cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
In-Reply-To: <493CFE3E.7080200@hartkopp.net>
Message-ID: <alpine.LFD.2.00.0812080724590.3425@nehalem.linux-foundation.org>
References: <1227613431.4259.1537.camel@twins>  <1228385830.5092.43.camel@twins> <493BB1EB.5000004@hartkopp.net>  <493BC8A8.2030200@hartkopp.net> <1228731359.5778.18.camel@twins> <493CFE3E.7080200@hartkopp.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Dec 2008, Oliver Hartkopp wrote:
>
> So your functionality reduction unfortunately get's a NACK from me ... sorry.

Quite frankly, your NAK doesn't matter.

We've had too many bugs in hrtimers. They _will_ get simplified. 

			Linus
