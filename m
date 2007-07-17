Return-Path: <linux-kernel-owner+w=401wt.eu-S933538AbXGQQzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538AbXGQQzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbXGQQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:55:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27487 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbXGQQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:55:40 -0400
Date: Tue, 17 Jul 2007 09:58:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mike@pikeaero.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: maintainer: parport drivers
Message-Id: <20070717095815.ae811965.randy.dunlap@oracle.com>
In-Reply-To: <1184688556.711.8.camel@jake>
References: <1184688556.711.8.camel@jake>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 12:09:16 -0400 Mike Sharkey wrote:

> Hello,
> 
> I understand there are currently no active maintainers of parport and
> friends - unless that has changed recently. 
> 
> We are heavy users of parport devices, and so I am offering to begin
> maintaining the parport drivers. I have spent some time studying the
> drivers closely, and I've read Love's book linux kernel development, so
> I think I'm just about ready for this.
> 
> My question is; what are some of the outstanding issues with parport
> which people would like to see addressed?

There are probably others, but "Advanced Search" at
bugzilla.kernel.org finds these 4 bug reports:

http://bugzilla.kernel.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=parport&long_desc_type=substring&long_desc=&kernel_version_type=allwordssubstr&kernel_version=&bug_status=NEW&bug_status=REOPENED&bug_status=ASSIGNED&emailassigned_to1=1&emailtype1=substring&email1=&emailassigned_to2=1&emailreporter2=1&emailcc2=1&emailtype2=substring&email2=&bugidtype=include&bug_id=&chfieldfrom=&chfieldto=Now&chfieldvalue=&regression=both&cmdtype=doit&order=Reuse+same+sort+as+last+time&field0-0-0=noop&type0-0-0=noop&value0-0-0=


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
