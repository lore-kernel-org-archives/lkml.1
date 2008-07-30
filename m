Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbYG3Kx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbYG3Kx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYG3KxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:53:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55752 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752858AbYG3KxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:53:20 -0400
Date: Wed, 30 Jul 2008 11:35:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mcs6502@gmail.com, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch 00/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs
 within VENDOR_IDs
Message-ID: <20080730113538.2a2422ba@lxorguk.ukuu.org.uk>
In-Reply-To: <20080730034255.ac5aa6c2.akpm@linux-foundation.org>
References: <E1KO7OU-0007BT-Ff@wraith.cs.uow.edu.au>
	<20080730034255.ac5aa6c2.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a) slam it into mainline immediately or
> 
> b) ask you to regenerate it during the 2.6.28 merge window or
> 
> c) forget the whole idea.

I vote for (a). At some point it needs doing and the sooner we do it the
better. I've scanned all the diffs and they appear correct. As we've seen
from the MAINTAINERS file once you get errors they spread rapidly.

Acked-by: Alan Cox <alan@redhat.com>
