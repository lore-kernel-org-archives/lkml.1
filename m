Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbYD2I5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbYD2I5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYD2I5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:57:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33804 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754047AbYD2I5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:57:40 -0400
Date: Tue, 29 Apr 2008 09:50:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "pradeep singh rautela" <rautelap@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Q]Can a file be dual licensed in upstream kernel?
Message-ID: <20080429095015.2e05f470@core>
In-Reply-To: <6bc632150804282237o1aa04e28t93f46874cd14721f@mail.gmail.com>
References: <6bc632150804282237o1aa04e28t93f46874cd14721f@mail.gmail.com>
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

On Tue, 29 Apr 2008 11:07:37 +0530
"pradeep singh rautela" <rautelap@gmail.com> wrote:

> Hi All,
> 
> A small query.
> Can a module/file be Dual licensed(i.e BSD/GPLv2) in the upstream
> Linux kernel sources?

The copy you submit to the kernel needs to be GPL. How you choose to
licence it in addition is your business (assuming it is all your own
work). Various drivers in the kernel (eg much of infiniband and ACPI) are
issued by their authors with multiple licences for different projects.

Alan
