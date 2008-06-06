Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbYFFUmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbYFFUmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbYFFUiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:38:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51755 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932908AbYFFUiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:38:01 -0400
Date: Fri, 6 Jun 2008 21:21:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Graf Yang <graf.yang@analog.com>, Bryan Wu <cooloney@kernel.org>,
       sonic.zhang@analog.com, linux-kernel@vger.kernel.org
Subject: Re: serial/bfin_5xx.c build error
Message-ID: <20080606212155.0b095c97@core>
In-Reply-To: <20080606162203.GB2201@cs181133002.pp.htv.fi>
References: <20080606162203.GB2201@cs181133002.pp.htv.fi>
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

> In case it can't be fixed quickly a revert might be an option for 2.6.26.

A revert wouldn't be an option as quick check would show you.

The needed enabler patch went into Linus tree so the other fix should
follow before 2.6.26 and all will be well.

Alan
