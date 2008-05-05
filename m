Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbYEEQVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbYEEQVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYEEQVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:21:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYEEQVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:21:12 -0400
Date: Mon, 5 May 2008 12:21:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210004250.17132.12.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0805051220590.25250@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com> 
 <1209753250.25628.34.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>
 <1210004250.17132.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 May 2008, Daniel Walker wrote:
> You really want bisection first. The reason is that you don't want ever
> growing patches, you want smaller and smaller patches. For instance the
> rt-mutex-core.patch is way too large, you wouldn't want to fold my
> PICK_FUNCTION changes into that patch since that would just make
> rt-mutex-core larger ..
>

Yeah, I already did that ;-)

-- Steve

