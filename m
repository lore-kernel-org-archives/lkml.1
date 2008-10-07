Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbYJGW7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbYJGW7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYJGW7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:59:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45179 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754209AbYJGW73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:59:29 -0400
Date: Tue, 7 Oct 2008 23:58:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       NetDev <netdev@vger.kernel.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, tglx@tglx.de,
       "Theodore Ts'o" <tytso@mit.edu>, linux-ide@vger.kernel.org
Subject: Re: Top kernel oopses/warnings for the week of October 7th, 2008
Message-ID: <20081007235833.1a89948f@lxorguk.ukuu.org.uk>
In-Reply-To: <200810072213.16103.rjw@sisk.pl>
References: <48EBBE15.9030905@linux.intel.com>
	<200810072213.16103.rjw@sisk.pl>
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

> This should have been fixed by:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f5a6d958b5d0a10e7e7a9dee1862fb31d08c6d26

You mean - hidden by - that change should IMHO be reverted

