Return-Path: <linux-kernel-owner+w=401wt.eu-S935059AbYEBONl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935059AbYEBONl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762885AbYEBONR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:13:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53270 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758962AbYEBONR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:13:17 -0400
Date: Fri, 2 May 2008 15:04:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frans Pop <elendil@planet.nl>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hfsplus: Correct user visible printk
Message-ID: <20080502150439.76beaf27@core>
In-Reply-To: <200805021600.42610.elendil@planet.nl>
References: <20080502142925.2e439d8a@core>
	<200805021600.42610.elendil@planet.nl>
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

> BTW, what is common spelling in the kernel British or American English?

It varies. The fs journal code uses both at random sometimes mixed in the
same paragraph. Fortunately "to journalise" is valid in both US and UK
English.

> journaled:     134,000 hits ( 8.7% of above total)

Almost entirely caused by Linux.

> I don't see this as an improvement.

Actually using proper language is most definitely an improvement. Right
now we are using incorrect made up words. Not only that we are using
incorrect made up words when the computing professional bodies also say
that our choice is wrong.

Alan
