Return-Path: <linux-kernel-owner+w=401wt.eu-S1764417AbYBONai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764417AbYBONai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbYBONab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:30:31 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57824 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754490AbYBONaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:30:30 -0500
Date: Fri, 15 Feb 2008 13:22:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Machine check exception with a kernel dependency
Message-ID: <20080215132241.23823d43@core>
In-Reply-To: <20080213162528.GA32635@janus>
References: <20080213162528.GA32635@janus>
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

On Wed, 13 Feb 2008 17:25:28 +0100
Frank van Maarseveen <frankvm@frankvm.com> wrote:

> On at least two Dell optiplex 755 systems with a Core 2 Duo I get
> 
> Feb 13 15:14:01 inari CPU 1: Machine Check Exception: 0000000000000004 
> Feb 13 15:14:01 inari CPU 0: Machine Check Exception: 0000000000000005 
> Feb 13 15:14:01 inari Bank 0: b200004000000800 
> Feb 13 15:14:01 inari Bank 5: b200221024080400 
> 
> 2.6.22.10 shows the problem, 2.6.24.2 ditto but I'm unable to reproduce
> it with 2.6.24-rc8. BIOS upgrade didn't help. Removing all PCI[e] cards
> didn't help either.

If you run the MCE numbers through a decoder what do you get back ?
