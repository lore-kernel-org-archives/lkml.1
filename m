Return-Path: <linux-kernel-owner+w=401wt.eu-S1758882AbXIVRmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbXIVRmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXIVRmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:42:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28630 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXIVRmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:42:15 -0400
Date: Sat, 22 Sep 2007 10:40:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <ak@suse.de>,
       oliver.pntr@gmail.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/50] x86: add cpu codenames for Kconfig.cpu
Message-Id: <20070922104007.5c745f83.randy.dunlap@oracle.com>
In-Reply-To: <20070922142325.GK11455@redhat.com>
References: <200709221231.836138000@suse.de>
	<20070921223202.2504813DCD@wotan.suse.de>
	<20070921224539.GD8127@redhat.com>
	<20070922065724.GA26550@uranus.ravnborg.org>
	<20070922142325.GK11455@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007 10:23:25 -0400 Dave Jones wrote:

> On Sat, Sep 22, 2007 at 08:57:24AM +0200, Sam Ravnborg wrote:
> 
>  > > This seems like yet another list that will need to be perpetually
>  > > kept up to date, and given 99% of users don't know the codename
>  > > of their core, just the marketing name, I question its value.
>  > 
>  > As a bare minimum requirement the list presented here shall use same
>  > names as used in /proc/cpuinfo
>  > 
>  > On this box I read:
>  > 
>  > vendor_id	: GenuineIntel
>  > model name	: Pentium III (Coppermine)
> 
> There are *dozens* of possible entries here, and always new ones.
> The list will become so cumbersome that searching for the name
> through the help text of each possible option will become a
> really boring task, that I doubt anyone will seriously do.

Yep.  help text:  see www.wikipedia.org :)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
