Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbZAKLan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbZAKLan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 06:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZAKLae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 06:30:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45838 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751088AbZAKLad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 06:30:33 -0500
Date: Sun, 11 Jan 2009 11:30:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joseluismarchetti@yahoo.com.br
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to access a regular file from within a module ?
Message-ID: <20090111113053.42dc34ad@lxorguk.ukuu.org.uk>
In-Reply-To: <888012.80064.qm@web34402.mail.mud.yahoo.com>
References: <888012.80064.qm@web34402.mail.mud.yahoo.com>
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

On Sat, 10 Jan 2009 19:44:55 -0800 (PST)
Jose Luis Marchetti <joseluismarchetti@yahoo.com.br> wrote:

> Hi,
> 
> I would like to open/read/write/close a regular file from my device
> driver.

You don't generally get to do this. What are you actually trying to
achieve ?
