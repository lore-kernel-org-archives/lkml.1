Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbXJVKES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbXJVKES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXJVKEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:04:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32886 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751250AbXJVKEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:04:08 -0400
Date: Mon, 22 Oct 2007 11:07:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>
Cc: "Crispin Cowan" <crispin@crispincowan.com>, linux-kernel@vger.kernel.org,
       "LSM ML" <linux-security-module@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071022110718.3f781108@the-village.bc.nu>
In-Reply-To: <200710220224.l9M2Og5t020815@sapphire.spiritone.com>
References: <200710220224.l9M2Og5t020815@sapphire.spiritone.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 19:24:42 -0700
"Thomas Fricaccia" <thomas_fricacci@yahoo.com> wrote:

> Yes, I think Crispin has succinctly summed it up:  irrevocably closing
> the LSM prevents commercial customers from using security modules other
> than that provided by their Linux distributor.  As Sarbanes-Oxley and
> other regulatory laws require these customers to use "standard
> kernels", the result is a rather dreary form of vendor lock-in, where the
> security framework is coupled to the distribution.

Crispin at least is providing genuine discussion points. Sarbox has
nothing to say on "using vendor linux kernels".

