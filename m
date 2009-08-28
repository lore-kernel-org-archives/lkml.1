Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbZH1S5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbZH1S5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZH1S5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:57:08 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:48593 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZH1S5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:57:04 -0400
Date: Fri, 28 Aug 2009 14:56:49 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com
Subject: Re: [PATCH 3/4] fujitsu-laptop: driver [un]registration fixes
In-reply-to: <200907310846.n6V8k2nd006757@mercury.physics.adelaide.edu.au>
Message-id: <alpine.LFD.2.00.0908281455010.23436@localhost.localdomain>
References: <200907310846.n6V8k2nd006757@mercury.physics.adelaide.edu.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, Jonathan Woithe wrote:

> [PATCH 3/4] fujitsu-laptop: driver [un]registration fixes
> 
> >From Bartlomiej Zolnierkiewicz.

This line needs to be the 1st in the message for the attribution
to work correctly, and it needs to follow this format:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> * Move led_classdev_unregister() calls from fujitsu_cleanup() to
>   acpi_fujitsu_hotkey_remove().

i fixed it manually and applied for 2.6.32.

thanks,
-Len Brown, Intel Open Source Technology Center

