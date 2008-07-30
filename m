Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbYG3OWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbYG3OWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYG3OWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:22:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49298 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752741AbYG3OWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:22:04 -0400
Date: Wed, 30 Jul 2008 15:04:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1]: fix NE2000 linkage error
Message-ID: <20080730150450.3bd7c853@lxorguk.ukuu.org.uk>
In-Reply-To: <200807301144.m6UBitOG022822@harpo.it.uu.se>
References: <200807301144.m6UBitOG022822@harpo.it.uu.se>
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

On Wed, 30 Jul 2008 13:44:55 +0200 (MEST)
Mikael Pettersson <mikpe@it.uu.se> wrote:

> Trying to build with CONFIG_NE2000=m fails with:

Yes I've sent patches to fix this to Jeff a couple of times.

Alan
