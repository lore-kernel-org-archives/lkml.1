Return-Path: <linux-kernel-owner+w=401wt.eu-S1423112AbXD3HeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423112AbXD3HeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423123AbXD3HeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:34:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:60827 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1423112AbXD3HeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:34:07 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX1+o99ttu7Woy9J9gT7+5JYk0dN33oywvLsYCeETPH
	Vttcrs4xgufgTy
Date: Mon, 30 Apr 2007 09:34:02 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@stusta.de>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070430073402.GA27563@merlin.emma.line.org>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@stusta.de>,
	Diego Calleja <diegocg@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007, Linus Torvalds wrote:

> What works is somebody who is a bugmaster, and it doesn't really matter 
> *what* bug tracker he points to (bugzilla being one of the possibilities, 
> although not necessarily the best, and absolutely NOT the only choice), 
> and turn them into emails. Once they are emails, bugzilla can track them.

While I'm not reading this entire thread for lack of time:

This looks exactly like the kind of bug tracking that Timo Sirainen of
Dovecot fame concocted and talked about on the dovecot-users list,
quote:

| Dovecot BTS
| -----------
|
|The preferred way to report bugs is to send them to dovecot-bugs at
|dovecot.org. The only thing it does is prefix the subject line with [BUG
|#nnn] and forward it to dovecot at dovecot.org.
|
|Now everyone can reply to it just as it was a normal mailing list mail.
|As long the subject contains the "[BUG #nnn]" prefix, it's part of the
|bug.
|
|Existing mailing list threads can also be turned into bugs by replying
|to the thread's root message with To: dovecot-bugs at dovecot.org. This
|again causes the new reply to contain [BUG #nnn] prefix.
|
|Then comes the web part. [...]"      -- quoting Timo Sirainen
<http://www.dovecot.org/list/dovecot/2007-January/018786.html>

Perhaps it's a stripped-down sibling of the Debian BTS without itself
knowing :-) anyways, it's E-Mail centric, low ceremony, devised from the
currently implemented workflow.

I haven't followed its details, portability, shape, state or anything,
but the requirements appear very similar to Linus's -- at least to me
with entirely outside view (I've never used kernel bugzilla), so it
might be a starting point, conceptionally or with some luck even
implementation-wise.

(Yes I know it's going to be tough to obtain all the precioussssssss
bugssssssssssss from bugzzzzzzzzzzzzzzzilla but anyways, if nobody likes
to use it, something will be done and if only neglect...)

HTH

-- 
Matthias Andree
