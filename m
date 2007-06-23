Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbXFWQM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbXFWQM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXFWQMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:12:19 -0400
Received: from verein.lst.de ([213.95.11.210]:47273 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbXFWQMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:12:18 -0400
From: Torsten Duwe <duwe@lst.de>
Organization: LST e.V.
To: Grozdan Nikolov <microchip@chello.be>
Subject: Re: How innovative is Linux?
Date: Sat, 23 Jun 2007 18:12:02 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200706231417.16086.microchip@chello.be> <200706231722.26931.microchip@chello.be> <20070623164608.05dc5c30@the-village.bc.nu>
In-Reply-To: <20070623164608.05dc5c30@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231812.02317.duwe@lst.de>
X-Spam-Score: 0.001 () BAYES_50
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Alan Cox wrote:

> A few innovations that afaik first appeared the Linux kernel
> - Making multiple hosts appear transparently as one IP address
> - Futex fast hybrid locking
> - Single pass checksum fragment and send fragments in reverse order
> - Reiserfs - very innovative design, but innovation isn't neccessarily
> success
> - JFFS/JFFS2 - flash wear levelled file system avoiding all the problem
> patents
> - Loadable modules for a non-microkernel
- ALSA framework and drivers
- Direct Rendering Infrastructure
- hotplugging

> I'd argue the lack of a stable kernel internal API is also an innovation
The userland API _is_ stable; a stable intra-kernel API would *hinder* 
innovation ;-)

> The basis of building great free software projects is sharing and mixing,
> not sitting in a lab inventing something cool from scratch.
Generally, OS kernels have adopted and improved each others' ideas since the 
term was coined. Simply pulling out the Linux kernel and stating it has 
re-implemented more features than it innovated itself simply isn't fair. The 
same holds true for _any_ of the others!

BTW, PAM and NIS are userland. Certainly you don't want to compare even an 
average Linux distro with a plain solaris, AIX or *BSD* installation?

Also keep in mind that the Linux kernel is highly portable (handheld to 
mainframe), maybe only matched by NetBSD. This requires a major amount of 
maintenance care and some extra work for each new feature. And BSDs are not 
Unix, strictly speaking; Unix has "ripped off" BSD, as you would say.

You have simply fallen for some highly biased articles, if not propaganda.

	Torsten
