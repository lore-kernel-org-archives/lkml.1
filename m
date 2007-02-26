Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXBZQm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXBZQm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXBZQm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:42:56 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:20609 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbXBZQm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:42:56 -0500
Date: Mon, 26 Feb 2007 08:38:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: malc <av1474@comtv.ru>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: CPU load
Message-Id: <20070226083807.4ac704b1.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0702261338520.2356@linmac.oyster.ru>
References: <loom.20070212T063225-663@post.gmane.org>
	<20070212143219.GB5226@ucw.cz>
	<Pine.LNX.4.64.0702140059390.727@home.oyster.ru>
	<200702140908.44934.kernel@kolivas.org>
	<Pine.LNX.4.64.0702141023000.672@home.oyster.ru>
	<20070214204515.GA26153@elf.ucw.cz>
	<Pine.LNX.4.64.0702251334200.17241@linmac.oyster.ru>
	<20070226092837.GB3790@elf.ucw.cz>
	<Pine.LNX.4.64.0702261338520.2356@linmac.oyster.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007 13:42:50 +0300 (MSK) malc wrote:

> On Mon, 26 Feb 2007, Pavel Machek wrote:
> 
> > Hi!
> >
> >> [..snip..]
> >>
> >>>> The current situation ought to be documented. Better yet some flag
> >>>> can
> >>>
> >>> It probably _is_ documented, somewhere :-). If you find nice place
> >>> where to document it (top manpage?) go ahead with the patch.
> >>
> >>
> >> How about this:
> >
> > Looks okay to me. (You should probably add your name to it, and I do
> > not like html-like markup... plus please don't add extra spaces
> > between words)...
> 
> Thanks. html-like markup was added to clearly mark the boundaries of
> the message and the text. Extra-spaces courtesy emacs' C-0 M-q.
> 
> >
> > You probably want to send it to akpm?
> 
> Any pointers on how to do that and perhaps preferred submission
> format?
> 
> [..snip..]

Well, he wrote it up and posted it at
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
