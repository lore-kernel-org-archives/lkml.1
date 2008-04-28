Return-Path: <linux-kernel-owner+w=401wt.eu-S965707AbYD1TEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965707AbYD1TEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937407AbYD1TDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:03:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936551AbYD1TDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:03:52 -0400
Date: Mon, 28 Apr 2008 15:03:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 0/4] nmi_watchdog fixes for -rt
In-Reply-To: <48161325.1080508@ct.jp.nec.com>
Message-ID: <Pine.LNX.4.58.0804281503300.4615@gandalf.stny.rr.com>
References: <48161325.1080508@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 28 Apr 2008, Hiroshi Shimamoto wrote:

> Hi,
>
> Here is a patchset of nmi_watchdog fixes for -rt kernel.
> These patches are against 2.6.24.4-rt4.
> Could you please review?

Patches look good!

I'll queue them up for the next release.

Thanks,

-- Steve

