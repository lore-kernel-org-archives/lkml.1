Return-Path: <linux-kernel-owner+w=401wt.eu-S2992478AbXDELNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992478AbXDELNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 07:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992490AbXDELNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 07:13:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59747 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992478AbXDELNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 07:13:50 -0400
Date: Thu, 5 Apr 2007 12:16:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] doc/kernel-parameters: use IA-32 tag instead of i386
Message-ID: <20070405121650.4739b5de@the-village.bc.nu>
In-Reply-To: <20070404220534.36cd24e9.randy.dunlap@oracle.com>
References: <20070404220534.36cd24e9.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 22:05:34 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Use documented tag for "IA-32" (not "i386") to indicate which
> kernel parameters apply to IA-32.

NAK. IA-32 is an Intel specific term, and I believe a protected mark at
that.

