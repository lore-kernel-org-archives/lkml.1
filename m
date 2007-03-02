Return-Path: <linux-kernel-owner+w=401wt.eu-S2992661AbXCBRei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992661AbXCBRei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992665AbXCBRei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:34:38 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:41579 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992661AbXCBReh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:34:37 -0500
Date: Fri, 2 Mar 2007 09:30:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070302093057.a68aec09.randy.dunlap@oracle.com>
In-Reply-To: <20070302030405.22f78999.akpm@linux-foundation.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<20070302030405.22f78999.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 03:04:05 -0800 Andrew Morton wrote:

> On Fri, 2 Mar 2007 03:00:26 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> 
> Forget to mention:  there's a huge wireless update in there:
> 
>    Changes include the new wireless stack, the associated drivers, and
>    the new wireless configuration mechanisms, as well as some b44 changes
>    related to hardware in-common with bcm43xx.  There are currently over
>    700 individual patches in the entire series.  I have the individual
>    patches extracted and available here:
> 
>      	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-dev/mm-master
> 
> please be sure to cc netdev@vger.kernel.org if anything goes wrong with it.

s/netdev/linux-wireless/ please:

NETWORKING [WIRELESS]
P:	John W. Linville
M:	linville@tuxdriver.com
L:	linux-wireless@vger.kernel.org
T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
S:	Maintained


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
