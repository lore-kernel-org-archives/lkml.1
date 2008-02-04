Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbYBDV0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbYBDV0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbYBDV0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:26:39 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48868 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500AbYBDV0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:26:38 -0500
Date: Mon, 4 Feb 2008 22:26:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: vmlinux_64.lds.S - use THREAD_SIZE instead of numeric constant
Message-ID: <20080204212643.GA17604@uranus.ravnborg.org>
References: <20080204171037.GA6743@cvg> <20080204202241.GA16919@uranus.ravnborg.org> <20080204203315.GA31341@elte.hu> <47A777FD.7080208@zytor.com> <aa79d98a0802041312j442c99d5sf702a54202c34963@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa79d98a0802041312j442c99d5sf702a54202c34963@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 12:12:32AM +0300, Cyrill Gorcunov wrote:
> Sam, Ingo, Peter, i didn't commented it 'cause there was no comment in
> 32bit version. And Sam, you are so right - i spent some time on trying
> to remember that 8192 bytes trick, and it seems it's not actual
> anymore for 64bits cpu. As punishment for myself i'm going to shut up
> for a week. Sorry for spent yours time.

Please take this as learning-by-doing - and continue to submit patches.
It it by no means the last time you are asked to do something different.
It happens all the time for all of us.

	Sam
