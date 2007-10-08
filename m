Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXJHNww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXJHNww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 09:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXJHNwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 09:52:43 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:61300 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbXJHNwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 09:52:42 -0400
Date: Mon, 8 Oct 2007 09:52:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jaswinder Singh <jaswinderlinuxrt@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc9-rt2
In-Reply-To: <1985e0f60710070635l7016bad1t9c4d4cb1a966534f@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0710080951270.4846@gandalf.stny.rr.com>
References: <1191536413.5210.19.camel@localhost.localdomain>
 <1985e0f60710070635l7016bad1t9c4d4cb1a966534f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Sun, 7 Oct 2007, Jaswinder Singh wrote:

> Do you have any plans to support nested or reentrant Interrupt Handling schemes.
>

Hi Jaswinder,

Not sure what you mean by this, since interrupt handlers are run as
threads and are fully preemptible.

-- Steve

