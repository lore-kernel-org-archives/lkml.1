Return-Path: <linux-kernel-owner+w=401wt.eu-S935828AbZFOVxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935828AbZFOVxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZFOVxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:53:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:41019 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbZFOVxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:53:34 -0400
Subject: Re: linux-next: scsi tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1245078707.3858.0.camel@mulgrave.site>
References: <20090615121716.c5bc0655.sfr@canb.auug.org.au>
	 <1245078707.3858.0.camel@mulgrave.site>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 07:40:00 +1000
Message-Id: <1245102000.12400.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 10:11 -0500, James Bottomley wrote:
> OK, dumped the offending patch, so it should be safe to take scsi-misc
> again.
> 
> I'm so used to merging these type of conversions, I didn't check that
> it
> was using a ps3 specific wrapper instead of a generic device one.

Do I have your Ack to merge the patch via the powerpc tree ?

Cheers,
Ben.


