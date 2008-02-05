Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbYBEVb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbYBEVb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbYBEVbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:31:16 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60235 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756377AbYBEVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:31:15 -0500
Date: Tue, 5 Feb 2008 21:25:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glenn Griffin <ggriffin.kernel@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
Message-ID: <20080205212528.5f1e5a32@core>
In-Reply-To: <Pine.LNX.4.64.0802052056120.16441@fbirervta.pbzchgretzou.qr>
References: <47a79d64.16538c0a.5b6a.ffffb0fe@mx.google.com>
	<20080205155558.GA23145@one.firstfloor.org>
	<Pine.LNX.4.64.0802052056120.16441@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >So I don't think it makes much sense to add more code to it, sorry.
> 
> Distributions should then probably deactivate it by default.
> SUSE 10.3 for example still has it enabled on default installs.

Even though I work the loyal opposition to SuSE I'd say SuSE 10.3 is
correct in having it enabled in the build.

Alan
