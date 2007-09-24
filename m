Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbXIXUcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbXIXUcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbXIXUb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:31:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60754 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751074AbXIXUbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:31:55 -0400
Date: Mon, 24 Sep 2007 21:38:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: IDE broken on Pegasos PPC platform
Message-ID: <20070924213814.7047800c@the-village.bc.nu>
In-Reply-To: <46F80BB1.7050902@redhat.com>
References: <46F80BB1.7050902@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 15:10:41 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> Without this patch, taken from a Suse 2.6.22 kernel, the Pegasos
> PPC machines can't use their IDE interface. Is this the right fix?

I believe so yes
