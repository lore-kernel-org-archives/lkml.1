Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbXJ3WUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbXJ3WUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbXJ3WUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:20:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51163 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751340AbXJ3WUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:20:38 -0400
Date: Tue, 30 Oct 2007 22:22:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>, mikael.starvik@axis.com,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 10/16] CRIS architecture: Correct compile errors
Message-ID: <20071030222219.45dc3610@the-village.bc.nu>
In-Reply-To: <20071030151417.43d2f286.akpm@linux-foundation.org>
References: <20071030093328.GM11960@axis.com>
	<20071030151417.43d2f286.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 15:14:17 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 30 Oct 2007 10:33:28 +0100
> Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> 
> > New and improved serial driver for cris v10.
> 
> I wasn't able to apply this due to extensive patch rejects.

Jesper - can you send me a copy of the serial driver for review as well
please. I'm trying to get the serial layer into conformance with
standards and good behaviour so would appreciate the opportunity to
review new entrants.

Alan
