Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbXGCFOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbXGCFOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbXGCFN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:13:57 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41255 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbXGCFN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:13:56 -0400
Date: Mon, 2 Jul 2007 22:13:36 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>, linux-usb-devel@lists.sourceforge.net
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node
Message-ID: <20070703051336.GF18420@kroah.com>
References: <200706291326.43563.yinghai.lu@sun.com> <200707021537.13840.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707021537.13840.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 03:37:13PM -0700, Yinghai Lu wrote:
> [PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node

Um, your subject doesn't match the patch below.  You might want to
verify it again...

I'll not apply any of these until the subject gets straightened out from
the body of the patch, and you can show a real benifit for these
changes.

thanks,

greg k-h
