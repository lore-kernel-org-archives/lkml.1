Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbXEQXpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbXEQXpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760406AbXEQXpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:45:23 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16922 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759786AbXEQXpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:45:22 -0400
Date: Thu, 17 May 2007 16:49:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Further update of the i386 boot documentation
Message-Id: <20070517164906.c7b96fe9.randy.dunlap@oracle.com>
In-Reply-To: <464CE5A4.3040106@goop.org>
References: <200705172250.l4HMol8f004870@tazenda.hos.anvin.org>
	<464CE105.7030808@goop.org>
	<464CE38B.8010802@zytor.com>
	<464CE5A4.3040106@goop.org>
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

On Thu, 17 May 2007 16:30:44 -0700 Jeremy Fitzhardinge wrote:

> >>> +  If set to a nonzero value, contains a pointer to a null-terminated
> >>>   
> >>>       
> >> "nil-terminated"? "\0-terminated"?
> >>     
> >
> > Uh?  That seems more than a little silly.  Yes, I guess formally
> > speaking we're talking about "NUL-terminated", but the term
> > "null-terminated" has over 800,000 hits on Google -- 10 times as many as
> > "NUL-terminated" -- and is hardly an ambiguous term ("NUL-terminated" is
> > ugly, and "zero-terminated" is ambiguous.)
> >   
> 
> 0x00 or \0-terminated is idiomatic and unambigous.  Not a big deal
> either way.

I've mostly seen it as NUL-terminated.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
