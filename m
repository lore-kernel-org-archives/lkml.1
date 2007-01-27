Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbXA0BK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbXA0BK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 20:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXA0BK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 20:10:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34850 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXA0BK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 20:10:58 -0500
Date: Fri, 26 Jan 2007 17:10:48 -0800
From: Andrew Morton <akpm@osdl.org>
To: John Keller <jpk@sgi.com>
Cc: linux-acpi@vger.kernel.org, len.brown@intel.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       gregkh@suse.de, linux-kernel@vger.kernel.org, ayoung@sgi.com,
       jes@sgi.com
Subject: Re: [PATCH 1/3] - Altix: ACPI SSDT PCI device support
Message-Id: <20070126171048.5f0bf293.akpm@osdl.org>
In-Reply-To: <20061115152454.6047.64973.sendpatchset@attica.americas.sgi.com>
References: <20061115152454.6047.64973.sendpatchset@attica.americas.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Nov 2006 09:24:54 -0600
John Keller <jpk@sgi.com> wrote:

> Add SN platform support for running with an ACPI
> capable PROM that defines PCI devices in SSDT
> tables. There is a SSDT table for every occupied
> slot on a root bus, containing info for every
> PPB and/or device on the bus. The SSDTs will be
> dynamically loaded/unloaded at hotplug enable/disable.

An additional 600kb of diff has just popped up in the ACPI tree, so none of
this patch applies any more.  I'll need to drop it again, sorry.

It's been over two months - I'm not sure why things are so difficult for
this patchset.

