Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZBRVDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZBRVDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZBRVC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:02:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39831 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753012AbZBRVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:02:57 -0500
Date: Wed, 18 Feb 2009 21:34:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       pierre-marc.fournier@polymtl.ca
Subject: Re: Moving Userspace RCU (urcu) from GPL to LGPL license
Message-ID: <20090218213448.3b467c88@the-village.bc.nu>
In-Reply-To: <20090218180232.GA21389@Krystal>
References: <20090218180232.GA21389@Krystal>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 13:02:32 -0500
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> only thing is that we cannot put GPL code into a LGPL library.

You'll need a patent grant from IBM for non GPL use for that not just an
LGPL library
 
> The other point is that I use a few low-level primitives from the Linux
> kernel header (e.g. atomic increment for x86, barrier macros). Those are
> simple one-liners, but, still, I wonder about the licensing
> implications. I could simply "rewrite" them, but that would be a shame

Ask the author - certainly the original basic atomic ops Linus gave
specific permission to the mozilla folks to use under other licences.

Alan
