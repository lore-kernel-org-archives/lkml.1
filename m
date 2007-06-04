Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbXFDOwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbXFDOwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbXFDOwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:52:21 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:38714 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbXFDOwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:52:20 -0400
Subject: Re: [PATCH] m68k: Atari SCSI driver update_timeout removal
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <20070604072839.GA15390@infradead.org>
References: <Pine.LNX.4.64.0706031250190.9351@anakin>
	 <20070604072839.GA15390@infradead.org>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 09:52:16 -0500
Message-Id: <1180968737.3711.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 08:28 +0100, Christoph Hellwig wrote:
> On Sun, Jun 03, 2007 at 12:55:04PM +0200, Geert Uytterhoeven wrote:
> > From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
> > 
> > Atari SCSI driver fixes: remove update_timeout kludge
> 
> Looks good. James, can you send this on for 2.6.22 so the accidentally
> added cludge doesn't end up in any release version?

Yes, sure ... I'm just preparing the -rc updates for SCSI now.

James


