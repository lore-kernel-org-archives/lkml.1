Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYGJLu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYGJLu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYGJLuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:50:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60404 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751017AbYGJLuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:50:20 -0400
Date: Thu, 10 Jul 2008 12:17:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: drzeus-mmc@drzeus.cx, akpm@linux-foundation.org, dhowells@redhat.com,
       alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix SDIO break control to now return success or an
 error
Message-ID: <20080710121717.11b5faa1@the-village.bc.nu>
In-Reply-To: <20080710112847.22339.88592.stgit@warthog.procyon.org.uk>
References: <20080710112847.22339.88592.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 12:28:48 +0100
David Howells <dhowells@redhat.com> wrote:

> Fix SDIO break control to now return success or an error.
> 
> This is a consequence of patch 9ea761bfef52c116fed4715d4043392c2503fe6a.

Thanks. Thats what you get for hiding your tty drivers in weird places.

