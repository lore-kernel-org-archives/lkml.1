Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbXIUKcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbXIUKcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbXIUKc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:32:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33548 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755333AbXIUKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:32:24 -0400
Date: Fri, 21 Sep 2007 11:39:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Peer Chen" <peerchen@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
Subject: Re: [PATCH] ahci: Add MCP79 support to AHCI driver
Message-ID: <20070921113908.180cd154@the-village.bc.nu>
In-Reply-To: <200709211406065332552@gmail.com>
References: <200709211406065332552@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 14:06:10 +0800
"Peer Chen" <peerchen@gmail.com> wrote:

> Add the MCP79 support to ahci driver.
> The patch base on kernel 2.6.23-rc7

Is this actually needed or as they are standard ahci devices will the
class match get them anyway ?
