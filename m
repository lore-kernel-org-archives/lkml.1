Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYJUWt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYJUWt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYJUWtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:49:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37536 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751195AbYJUWtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:49:18 -0400
Date: Tue, 21 Oct 2008 23:49:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: kgdb 2.6.28 merge plans
Message-ID: <20081021234911.3813f17d@lxorguk.ukuu.org.uk>
In-Reply-To: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
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

> * kgdboc will request/allocate a tty so as to sync with
>   the user space with respect to having only one
>   invocation of the low level start up code.

The tty stuff for this is not 2.6.28 material

Alan
