Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbYKXSc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbYKXSc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYKXScO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:32:14 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51805 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750876AbYKXScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:32:13 -0500
Date: Mon, 24 Nov 2008 18:32:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Message-ID: <20081124183204.2d3734e3@lxorguk.ukuu.org.uk>
In-Reply-To: <492AF06A.8020004@rtr.ca>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
	<491E4092.5030804@shaw.ca>
	<20081115103424.34f01370@lxorguk.ukuu.org.uk>
	<491FBA29.3000803@kernel.org>
	<20081116112511.3913123a@lxorguk.ukuu.org.uk>
	<492AF06A.8020004@rtr.ca>
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

> Well ata_piix for starters.  Verified here by me.

Some piix are fine (mine are) so maybe its a device property in part.
Certainly it is needed for some combinations including current stuff like
jmicron PATA ports.
