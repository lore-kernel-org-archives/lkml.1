Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZFRG1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZFRG1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbZFRG1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:27:00 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:44032 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZFRG07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:26:59 -0400
Date: Thu, 18 Jun 2009 01:47:06 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for June 18
In-reply-to: <20090618145949.d933719a.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.00.0906180141130.8921@localhost.localdomain>
References: <20090618145949.d933719a.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Merging acpi/test
> CONFLICT (content): Merge conflict in drivers/platform/x86/Kconfig
> CONFLICT (content): Merge conflict in drivers/platform/x86/toshiba_acpi.c

Okay, I've dropped the toshiba_acpi branch from test, pending a refresh

> [master 28e994e] Revert "Merge branch 'oqo-wmi-EXPECT-REFRESH' into test"

Okay, I've dropped the oqo branch from test, pending a refresh

> CONFLICT (content): Merge conflict in drivers/platform/x86/eeepc-laptop.c

As I've sync'd my test tree with Linus' tree in preparation for
a merge, it seems that I need a refreshed eeepc-laptop branch too:-(

thanks,
-Len Brown, Intel Open Source Technology Center


