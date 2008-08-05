Return-Path: <linux-kernel-owner+w=401wt.eu-S1762698AbYHEMlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762698AbYHEMlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760857AbYHEMlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:41:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52166 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760679AbYHEMlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:41:01 -0400
Date: Tue, 5 Aug 2008 13:23:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Bryan Wu" <cooloney@kernel.org>
Cc: "Adrian Bunk" <bunk@kernel.org>, sonic.zhang@analog.com,
       linux-kernel@vger.kernel.org
Subject: Re: serial/bfin_5xx.c build error
Message-ID: <20080805132347.32a59aef@lxorguk.ukuu.org.uk>
In-Reply-To: <386072610808042058lf994767qd4c941d8dc13d7c8@mail.gmail.com>
References: <20080802181624.GQ19682@cs181140183.pp.htv.fi>
	<386072610808042058lf994767qd4c941d8dc13d7c8@mail.gmail.com>
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

> > <--  snip  -->
> 
> So is this bug in mainline upstream or linux-next latest tree?

2.6.27-rc - and I've sent Linus the fix

Alan
