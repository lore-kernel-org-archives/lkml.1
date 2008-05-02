Return-Path: <linux-kernel-owner+w=401wt.eu-S1765659AbYEBQnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765659AbYEBQnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbYEBQni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:43:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:42480 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757846AbYEBQnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:43:37 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18dvmBxQiEdtjuVLaaQUWSdIOXw+offKhhcnTOVGS
	Iq/6nF1tT7Fn4J
Date: Fri, 2 May 2008 18:43:34 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: CPU POSIX timers livelock
Message-ID: <20080502164334.GA3585@atjola.homenet>
References: <1209740741.15210.49.camel@elijah.suse.cz> <20080502152126.GA3130@atjola.homenet> <1209744785.15210.52.camel@elijah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1209744785.15210.52.camel@elijah.suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.05.02 18:13:05 +0200, Petr Tesarik wrote:
> On Fri, 2008-05-02 at 17:21 +0200, Björn Steinbrink wrote:
> > [Added Roland McGrath and Frank Mayhar to Cc:, as this sounds similar
> > enough to what has been discussed here http://lkml.org/lkml/2008/2/6/505]
> 
> Yes, I've just now found the thread too, read it, and I think this is
> just another case where the current implementation does not scale.
> 
> Was there any followup to the patch posted on the 7th of March? The
> interesting discussion seems to be interrupted there. :(

Hm, I have some message in that thread from April they don't seem to be
on lkml.org nor in the bugzilla though. Oh well, I can send you an mbox
of that thread in a private mail, just let me know if you want that.

Björn
