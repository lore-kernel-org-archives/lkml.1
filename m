Return-Path: <linux-kernel-owner+w=401wt.eu-S1765818AbYD1IoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765818AbYD1IoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYD1Inz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:43:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58584 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752990AbYD1Iny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:43:54 -0400
Date: Mon, 28 Apr 2008 09:36:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] drivers/usb annotations and fixes
Message-ID: <20080428093609.420392c2@core>
In-Reply-To: <E1JqMPQ-0004pD-0B@ZenIV.linux.org.uk>
References: <E1JqMPQ-0004pD-0B@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 07:00:16 +0100
Al Viro <viro@ftp.linux.org.uk> wrote:

> 
> * endianness annotations
> * endianness fixes
> * missing get_unaligned/put_unaligned
> 
> It's pretty much all over the place, changes to different files are independent.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


Serial parts

Acked-by: Alan Cox <alan@redhat.com>
