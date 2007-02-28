Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXB1BTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXB1BTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXB1BTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:19:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:45066 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXB1BTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:19:43 -0500
Date: Tue, 27 Feb 2007 17:15:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Seetharam Dharmosoth <seetharam_kernel@yahoo.co.in>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Need Help on Crash Dump in Kernel-2.6.20
Message-Id: <20070227171532.e3f7ab3c.randy.dunlap@oracle.com>
In-Reply-To: <979286.59445.qm@web7703.mail.in.yahoo.com>
References: <979286.59445.qm@web7703.mail.in.yahoo.com>
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

On Tue, 27 Feb 2007 13:22:56 +0000 (GMT) Seetharam Dharmosoth wrote:

> Hi,
> 
> I have one question regarding Crash Dump.
> 
> Is Kernel-2.6.20 having the default Crash dump in main
> tree?

2.6.20 has a CRASH_DUMP config option for some processor
architectures, such as ia64, i386, x86_64, powerpc.

You should read the help text for that config option as well
as the file Documentation/kdump/kdump.txt .

> As I know, LKCD is one of the Crash dump utility 
> software which can be used with Linux Kernel (it is a
> third party s/w).
> 
> can any one please tell me the right thing about Crash
> dump?



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
