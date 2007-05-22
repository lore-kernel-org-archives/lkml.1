Return-Path: <linux-kernel-owner+w=401wt.eu-S935480AbXEVTwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935480AbXEVTwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761736AbXEVTwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:52:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40904 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757790AbXEVTwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:52:37 -0400
Date: Tue, 22 May 2007 20:57:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Malton <chrism@cjsoftuk.dyndns.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NCPFS can't handle extended characters.
Message-ID: <20070522205723.0d0dc5ce@the-village.bc.nu>
In-Reply-To: <4652E735.7000206@cjsoftuk.dyndns.org>
References: <4652E735.7000206@cjsoftuk.dyndns.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 13:51:01 +0100
Chris Malton <chrism@cjsoftuk.dyndns.org> wrote:

> I found a bug in NCPFS that I haven't the time to fix right now.
> 
> Here's the problem: if a file contains an extended (Charcodes 128-255) 
> character, especially ` (or a even worse, an word converted ' (curled 
> apostrophe) NCPFS goes butter side down on the directory listing.

For any real hope to answer things like that it would be useful to have
precise descriptions of what fails, any messages logged when it occurs
etc.

Alan
