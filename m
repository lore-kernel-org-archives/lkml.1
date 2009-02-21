Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZBUEqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZBUEqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 23:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZBUEqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 23:46:43 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:59235 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZBUEqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 23:46:42 -0500
Date: Fri, 20 Feb 2009 23:46:31 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 0/2] PM: x86-64 suspend-resume fix
In-reply-to: <200902152244.47326.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.0902202345550.19156@localhost.localdomain>
References: <200902152244.47326.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 15 Feb 2009, Rafael J. Wysocki wrote:

> Hi,
> 
> The following two patches clean-up and fix the x86-64 resume code.
> 
> 1/2 is a cleanup, but it is simple enough to be applied now IMO.
> 
> 2/2 is a bug fix based on 1/2, which is 2.6.29 material.
> 
> Please apply them to the suspend branch and push to Linus for 2.6.29 (Ingo
> says he doesn't mind if they go through your tree).

1 & 2 applied to suspend branch.

thanks,
Len Brown, Intel Open Source Technology Center
