Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbYARPyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbYARPyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbYARPyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:54:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36343 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753703AbYARPyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:54:23 -0500
Date: Fri, 18 Jan 2008 15:52:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 6/7] Char: mxser, remove it
Message-ID: <20080118155240.07d53de6@lxorguk.ukuu.org.uk>
In-Reply-To: <1200666676-1234-6-git-send-email-jirislaby@gmail.com>
References: <1200666676-1234-1-git-send-email-jirislaby@gmail.com>
	<1200666676-1234-6-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 15:31:15 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> (Old) mxser is obsoleted by mxser_new and scheduled for removal on Dec 2007.
> Remove it by renaming mxser_new to mxser.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>(info->board->chip_flag)) {

All 7 parts 

Reviewed-by: Alan Cox <alan@redhat.com>
