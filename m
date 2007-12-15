Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbXLOC5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbXLOC5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 21:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXLOC5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 21:57:32 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43069 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbXLOC5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 21:57:31 -0500
Date: Fri, 14 Dec 2007 18:55:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.10
Message-Id: <20071214185546.2cf66f2a.randy.dunlap@oracle.com>
In-Reply-To: <20071214194952.GA15765@kroah.com>
References: <20071214194952.GA15765@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 11:49:53 -0800 Greg Kroah-Hartman wrote:

> We (the -stable team) are announcing the release of the 2.6.23.10 kernel.
> It a number of bugfixes and anyone using the 2.6.23 kernel series is
> recommended to upgrade.
> 
> I'll also be replying to this message with a copy of the patch between
> 2.6.23.9 and 2.6.23.10
> 
> The updated 2.6.23.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary


WARNING: vmlinux.o(.init.text.23+0x7e6b): Section mismatch: reference to .exit.text:br_fdb_fini (between 'br_init' and 'br_fdb_init')

Fixed by:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=73afc9069289bdb77cf0c81cb9775dcb63894bbe


---
~Randy
