Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbXFJHLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbXFJHLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 03:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760707AbXFJHLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 03:11:00 -0400
Received: from holomorphy.com ([66.93.40.71]:55756 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759806AbXFJHK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 03:10:59 -0400
Date: Sun, 10 Jun 2007 00:10:43 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070610071043.GB6909@holomorphy.com>
References: <46686810.6030805@redhat.com> <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com> <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com> <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu> <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com> <18026.15766.574693.200636@cargo.ozlabs.ibm.com> <Pine.LNX.4.64.0706090942210.14037@alien.or.mcafeemobile.com> <18027.39295.464374.371664@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18027.39295.464374.371664@cargo.ozlabs.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 04:26:07PM +1000, Paul Mackerras wrote:
> If you don't think we should be bound by POSIX, then you are perfectly
> free to go off and write your own research kernel with whatever
> interface you want, and no programs available to run on it. :)

This isn't fair to research kernels. Breaking applications is not an
active area of research.


-- wli
