Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbXEUQLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbXEUQLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbXEUQLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:11:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55426 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755131AbXEUQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:11:13 -0400
Date: Mon, 21 May 2007 17:15:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org
Subject: Re: Add Seagate STT20000A to DMA blacklist.
Message-ID: <20070521171551.0f81a0be@the-village.bc.nu>
In-Reply-To: <20070521145042.GA6957@redhat.com>
References: <20070521145042.GA6957@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 10:50:42 -0400
Dave Jones <davej@redhat.com> wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=1044
> has been open for _four_ years with a patch available.
> Here's a rediffed version of the same.

Please update libata as well when you udpate the blacklists.

Alan
