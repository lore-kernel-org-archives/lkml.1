Return-Path: <linux-kernel-owner+w=401wt.eu-S1161339AbXECVOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161339AbXECVOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031350AbXECVOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:14:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43261 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031349AbXECVOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:14:14 -0400
Date: Thu, 3 May 2007 22:17:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Remove apparently dead CONFIG_NO_ATA_LEGACY code.
Message-ID: <20070503221744.35975222@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0705031350550.11235@localhost.localdomain>
References: <Pine.LNX.4.64.0705031350550.11235@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 13:53:06 -0400 (EDT)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
> Remove the single snippet of code conditional on the non-existent
> CONFIG_NO_ATA_LEGACY Kconfig variable.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

NAK

This option is not dead and is relevant (although the platform using it
may not have the relevant bits merged yet).

