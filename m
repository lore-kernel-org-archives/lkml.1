Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbXHaWVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbXHaWVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXHaWVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:21:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbXHaWV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:21:29 -0400
Date: Fri, 31 Aug 2007 15:20:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250_pci: Autodetect mainpine cards
Message-Id: <20070831152058.92306a0c.akpm@linux-foundation.org>
In-Reply-To: <20070822230527.649f3714@the-village.bc.nu>
References: <20070822230527.649f3714@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 23:05:27 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Add support for a whole range of boards. Some are partly autodetected but
> not fully correctly others (PCI Express notably) not at all. Stick all
> the right entries in.
> 
> Thanks to Mainpine for information and testing.

drivers/serial/8250_pci.c:2584: error: 'PCI_VENDOR_ID_MAINPINE' undeclared here (not in a function)
drivers/serial/8250_pci.c:2584: error: 'PCI_DEVICE_ID_MAINPINE_PBRIDGE' undeclared here (not in a function)
