Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbYIKQVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbYIKQVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYIKQVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:21:46 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63129 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751986AbYIKQVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:21:45 -0400
Date: Thu, 11 Sep 2008 17:17:50 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Alex Nixon <alex.nixon@citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/MIPS Development <linux-mips@linux-mips.org>
Subject: Re: [PATCH 0/3] Globally defining phys_addr_t
In-Reply-To: <48C941FA.50500@goop.org>
Message-ID: <Pine.LNX.4.55.0809111716260.17757@cliff.in.clinika.pl>
References: <48C8D76B.10901@goop.org> <Pine.LNX.4.64.0809111202560.1545@anakin>
 <48C941FA.50500@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008, Jeremy Fitzhardinge wrote:

> > If I'm not mistaking, this is also true for some MIPS machines.
> >   
> 
> Nothing turns up in a grep over arch/mips and include/asm-mips.

 It's called phys_t for MIPS.  It's time to make it consistent probably.

  Maciej
