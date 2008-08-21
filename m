Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYHUKBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYHUKBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYHUKBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:01:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48120 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752697AbYHUKBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:01:03 -0400
Date: Thu, 21 Aug 2008 10:43:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       akpm@osdl.org
Subject: Re: [2.6.27-rc4] compilation warnings and section mismatches
Message-ID: <20080821104307.346cbcb7@lxorguk.ukuu.org.uk>
In-Reply-To: <48AD2701.2000304@numericable.fr>
References: <48AD2701.2000304@numericable.fr>
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

On Thu, 21 Aug 2008 10:27:45 +0200
Rufus & Azrael <rufus-azrael@numericable.fr> wrote:

> Hi all,
> 
> Here are my compilation warnings and section mismatches when building 
> the fresh rc4 kernel version.
> 
> Hope it could help you to fix.

All harmless

And patches to the skfp one have been posted repeatedly so I've no idea
why they are still not in 2.6.27-rc - has Mr Garzik disappeared because
some of the ATA ones are missing too like the LBA48 off by one fix ?

Alan
