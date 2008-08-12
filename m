Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbYHLXNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbYHLXNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYHLXMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:12:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56765 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754AbYHLXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:12:55 -0400
Date: Tue, 12 Aug 2008 23:55:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joerg Roedel <joro@8bytes.org>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Setup code crashes my old 486 box
Message-ID: <20080812235535.18f7519c@lxorguk.ukuu.org.uk>
In-Reply-To: <48A2155B.1020904@zytor.com>
References: <20080812224703.GV31439@8bytes.org>
	<48A2155B.1020904@zytor.com>
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

> Right in concept, but I dislike the implementation (duplication of the 
> CPU detect code we already have).  Could you try this patch and see if 
> it works for you?

I was under the impression that spudstop came in with the Pentium II so
presumably < 6 would be even safer ?

Alan
