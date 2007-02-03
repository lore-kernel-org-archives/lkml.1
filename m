Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXBCTuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXBCTuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 14:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbXBCTuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 14:50:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34335 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751393AbXBCTuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 14:50:10 -0500
Date: Sat, 3 Feb 2007 20:02:09 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andrew Morton <akpm@osdl.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag
 string termination trick
Message-ID: <20070203200209.4f931fdc@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007 03:08:14 +0100 (CET)
Bodo Eggert <7eggert@gmx.de> wrote:

> This patch changes the module license handling code to:
> - allow modules to have multiple licenses

NAK

> - access GPL symbols if at least one license is GPL-compatible

NAK

The legal boundary of a work is not "the file".
