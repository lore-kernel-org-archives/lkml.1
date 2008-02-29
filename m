Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbYB2Pbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbYB2Pbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYB2PbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:31:22 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58411 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYB2PbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:31:22 -0500
Date: Fri, 29 Feb 2008 16:31:20 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: 64-bit sources
In-Reply-To: <Pine.LNX.4.61.0802290954390.22942@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0802291631020.24056@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.61.0802290954390.22942@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 29 2008 10:07, linux-os (Dick Johnson) wrote:
>Hello all,
>
>I inherited a problem with linux-2.6.11-1.1369_FC4smp in
>that plugging in a USB mouse on a new AMD machine causes
>a crash. I took a new disk and installed the complete
>installation from "Fedora core." The sources provided
>with the distribution do not compile with the tools
>provided with the distribution! I need to find the
>real sources for this kernel, something that will
>compile so I can add some debugging info in the
>ohci-hcd driver.
>
>Checking the web only shows a ".rpm" that contains
>only patches, no source. What goes? Is this a secret
>distribution?

This one?
http://ftp-stud.hs-esslingen.de/pub/fedora/linux/core/4/SRPMS/kernel-2.6.11-1.1369_FC4.src.rpm
