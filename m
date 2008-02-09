Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYBIN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYBIN7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYBIN7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:59:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44043 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755249AbYBIN7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:59:12 -0500
Date: Sat, 9 Feb 2008 13:51:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] docbook: drop z85230 library from kernel-api
Message-ID: <20080209135141.76fb815d@core>
In-Reply-To: <20080208203223.85a288a3.randy.dunlap@oracle.com>
References: <20080208203223.85a288a3.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 20:32:23 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> Drop z85230 support library info from kernel-api since it's duplicated
> in the Z85230 book.
> 
> Alan, is this OK with you?
> (This is one of several patches that I have my queue for reducing the
> size of kernel-api.* .)

Makes sense to me - its a specialist area

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Alan Cox <alan@redhat.com>
