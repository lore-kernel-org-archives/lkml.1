Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXF0HvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXF0HvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbXF0HvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:51:12 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:61798 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751029AbXF0HvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:51:11 -0400
Date: Wed, 27 Jun 2007 09:48:03 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-usb-devel@lists.sourceforge.net,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] Export usb_gadgetfs.h to userspace
Message-ID: <20070627094803.60ac7801@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070627003538.f15bef21.akpm@linux-foundation.org>
References: <11827637791662-git-send-email-hskinnemoen@atmel.com>
	<20070627003538.f15bef21.akpm@linux-foundation.org>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 00:35:38 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> `make headers_check' fails:
> 
> make[2]: *** No rule to make target `/usr/src/devel/include/linux/usb_gadgetfs.h', needed by `/usr/src/devel/usr/include/linux/usb_gadgetfs.h'.  Stop.

It has already been moved to linux/usb/gadgetfs.h and properly exported
in -mm. Please just ignore this patch, it's redundant.

Haavard
