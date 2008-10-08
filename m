Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYJHWIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYJHWIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbYJHWI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:08:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49608 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754591AbYJHWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:08:29 -0400
Date: Wed, 8 Oct 2008 23:08:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Davi Leal <davi@leals.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: free tg3 ethernet driver
Message-ID: <20081008230827.6e1423fe@lxorguk.ukuu.org.uk>
In-Reply-To: <200810082353.31033.davi@leals.com>
References: <200810082353.31033.davi@leals.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 23:53:30 +0200
Davi Leal <davi@leals.com> wrote:

> We would like to have a tg3 driver which would be accepted as free by the 
> FSF's standards.

Well if you want to write new firmware for the device you'll need to
reverse engineer the chip internals or convince Broadcom to document them
for you. I suspect you'll have to get to the point of xraying the
component slice by slice and need a multi-million dollar budget.

Alan
