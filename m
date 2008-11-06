Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYKFKVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYKFKVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYKFKVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:21:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52605 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753369AbYKFKVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:21:05 -0500
Date: Thu, 6 Nov 2008 10:18:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "William L. Irwin" <wli@holomorphy.com>, <sparclinux@vger.kernel.org>
Subject: Re: tty warning
Message-ID: <20081106101852.429f4a6c@lxorguk.ukuu.org.uk>
In-Reply-To: <20081106152421.a9cf964f.sfr@canb.auug.org.au>
References: <20081106152421.a9cf964f.sfr@canb.auug.org.au>
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

On Thu, 6 Nov 2008 15:24:21 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Alan,
> 
> A sparc allmodconfig build gives these warnings:

Blame Dave, although its a bit unfair as the Sparc32 does some weirdness
that the compiler didn't use to be smart enough to complain about and is
actually valid for sparc32 at least.

Alan
