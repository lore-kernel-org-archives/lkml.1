Return-Path: <linux-kernel-owner+w=401wt.eu-S1761066AbXGIQnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066AbXGIQnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXGIQl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:41:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51236 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758592AbXGIQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:41:26 -0400
Date: Mon, 9 Jul 2007 17:45:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Zhang Rui <rui.zhang@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
Message-ID: <20070709174544.2a6b7067@the-village.bc.nu>
In-Reply-To: <20070709145755.GD3492@stusta.de>
References: <20070709145755.GD3492@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 16:57:56 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> This patch contains the scheduled removal of the ACPI procfs interface.

NAK


What part of "we do not gratuitously break user space interfaces" is so
hard for people to understand.
