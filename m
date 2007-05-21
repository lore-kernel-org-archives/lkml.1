Return-Path: <linux-kernel-owner+w=401wt.eu-S1762248AbXEUXMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762248AbXEUXMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbXEUXMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:12:15 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:47348 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756509AbXEUXMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:12:15 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200705212312.l4LNC9VN009317@turbo.physics.adelaide.edu.au>
Subject: Re: 2.6.21.1 on Fedora Core 6 breaks LVM/vgscan
To: mau@oscar.ping.de (Patrick Mau)
Date: Tue, 22 May 2007 08:42:09 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org
In-Reply-To: <20070521182005.GA14390@oscar.prima.de> from "Patrick Mau" at May 21, 2007 08:20:05 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > There is still a problem with the CDROM but I will follow up in another
> > thread about that.
> 
> Did you mention ata_piix ?
> 
> With a recent git kernel, which I forgot, I was unable to read or eject
> DVD's. (Un-encrypted, BTW).

In my case the kernel isn't even detecting the drive at boot.

Regards
  jonathan
--
"Time is an illusion; lunchtime doubly so"
