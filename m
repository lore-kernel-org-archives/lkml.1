Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbXEEP0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbXEEP0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbXEEP0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:26:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:40548 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755029AbXEEPZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:25:07 -0400
X-Authenticated: #36390367
X-Provags-ID: V01U2FsdGVkX19rs0UJr+Rrx+2nHWvsCJ+b/q0rrdxv9wUE1kU8xh
	1lI8ippBid0ekR
From: Markus =?iso-8859-1?q?Ko=DFmann?= <mkossmann_ml1@gmx.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: parallel port problems with 2.6.21_rc5 and 2.6.21_rc6_git3-20070410174235
Date: Sat, 5 May 2007 16:58:22 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200704112040.23505.mkossmann_ml1@gmx.de> <20070503132513.e3db44e9.randy.dunlap@oracle.com>
In-Reply-To: <20070503132513.e3db44e9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705051658.22817.mkossmann_ml1@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. Mai 2007 schrieb Randy Dunlap:
> On Wed, 11 Apr 2007 20:40:23 +0200 Markus Koßmann wrote:
> > When using either the unpatched  2.6.21_rc5   or SUSEs patched
> > 2.6.21_rc6_git3-20070410174235 on a SUSE-10.2 x86_64 system the parallel
> > port doesn't work right. If I "cat some_asciifile >/dev/lp0"  the output
> > on my Epson Stylus Color 880 is unreadable.  "cat /dev/zero >/dev/lp0" 
> > creates random characters on the paper. Printing using cups also doesn't
> > work any more.
> > Switching back to SUSEs  2.6.18.8-0.1 kernel fixes the problem.
> > Any Ideas, what might be broken here ?
>
> Nope, but I have the same problem.
> I'll dig into it some day, but it's not very high priority for me.
>
> I haven't tested it lately.  Do you still see this problem?
>
Yes, it still exists with SUSEs  2.6.21-20070502152652 kernel. Didn't check 
with vanilla 2.6.21 yet. 

