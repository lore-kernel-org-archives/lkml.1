Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYIILPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYIILPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 07:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYIILOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 07:14:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52430 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752676AbYIILOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 07:14:52 -0400
Date: Tue, 9 Sep 2008 12:13:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Message-ID: <20080909121321.5a67f64e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080909074018.GA26076@Chamillionaire.breakpoint.cc>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
	<20080909074018.GA26076@Chamillionaire.breakpoint.cc>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you rely on this specific major? Since your daemon opens /dev/lirc0
> you don't need a fixed major do you?

Needs to change anyway 60 is already assigned for local and experimental
use.

Alan
