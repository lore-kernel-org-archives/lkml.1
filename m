Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYH1MpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYH1MpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYH1Mou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:44:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34243 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbYH1Mou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:44:50 -0400
Date: Thu, 28 Aug 2008 08:44:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: disable tracing for hibernation
In-Reply-To: <200808281439.13959.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.10.0808280844160.14580@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com> <200808271526.46868.rjw@sisk.pl> <200808281439.13959.rjw@sisk.pl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2008, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ftrace: disable tracing for hibernation
>     
> In accordance with commit f42ac38c59e0a03d6da0c24a63fb211393f484b0
> ("ftrace: disable tracing for suspend to ram"), disable tracing
> around the suspend code in hibernation code paths.
>     
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looks good to me, Thanks Rafael!

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

