Return-Path: <linux-kernel-owner+w=401wt.eu-S1764160AbYEGPlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764160AbYEGPlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761137AbYEGPkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:40:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59117 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759465AbYEGPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:40:10 -0400
Date: Wed, 7 May 2008 16:30:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <JosephChan@via.com.tw>
Cc: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH 2/9] viafb: VIA Frame Buffer Device
 Driver
Message-ID: <20080507163015.3e1c9abf@core>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67753@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67753@exchtp03.taipei.via.com.tw>
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


>
> +u16 red256[] = {

Asking for clashes again - naming issues.

Also stuff that cannot be changed is best marked const.
