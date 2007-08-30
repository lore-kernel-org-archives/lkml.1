Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXH3XOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXH3XOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 19:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbXH3XOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 19:14:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56621 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757748AbXH3XN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 19:13:58 -0400
Date: Fri, 31 Aug 2007 00:22:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, dex@dragonslave.de
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
Message-ID: <20070831002214.7fb5340d@the-village.bc.nu>
In-Reply-To: <200708301654.22346.a1426z@gawab.com>
References: <200708300731.20336.a1426z@gawab.com>
	<20070830110144.1e8020ec@the-village.bc.nu>
	<200708301654.22346.a1426z@gawab.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What's the max length of a 40wire cable to sustain 80wire cable 
> characteristics?

Depends on the materials and connector. The required electrical
characteristics for any cable are in the spec, and if you want to know
more you'll need to know a lot more than I do about transmission line
theory!
