Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbXJ3UHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbXJ3UHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXJ3UHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:07:22 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:60492 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXJ3UHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:07:21 -0400
Date: Tue, 30 Oct 2007 16:06:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Rui Nuno Capela <rncbc@rncbc.org>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.23.1-rt5 (was 2.6.23-rt1 trouble)
In-Reply-To: <47278BE5.9070401@rncbc.org>
Message-ID: <Pine.LNX.4.58.0710301605100.31349@gandalf.stny.rr.com>
References: <1192154640.15992.10.camel@localhost.localdomain>         
 <38542.213.58.131.130.1192445349.squirrel@www.rncbc.org> <471648B8.1030007@rncbc.org>
 <47234EA1.4050006@rncbc.org> <Pine.LNX.4.58.0710271203170.28617@gandalf.stny.rr.com>
 <47239A37.8000401@rncbc.org> <472781E3.7010103@rncbc.org>
 <Pine.LNX.4.58.0710301526480.30690@gandalf.stny.rr.com> <47278BE5.9070401@rncbc.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
> >
>
> yes, running without the *cough* nvidia module is under way. but do you
> remember that on my other laptop the freezes also happen and on that one
> there's no single proprietary modules in it? (same .config btw) problem
> is, like most modern laptops, it doesn't come bundled with a serial port
> so that can't give you a serial console evidence ...
>
> thanks for the reminder, anyway ;)
>

hmm, it could also be a separate issue. This other laptop is the one that
took a while to freeze. Correct?

Was it only on X apps? Or could it possible be something we could do via a
command line and then we could see vga output (if any).

-- Steve

