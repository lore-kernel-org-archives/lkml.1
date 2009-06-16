Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbZFPC0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbZFPC0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZFPCZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:25:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55760 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbZFPCZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:25:54 -0400
Subject: Re: linux-next: scsi tree build failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1245102000.12400.44.camel@pasglop>
References: <20090615121716.c5bc0655.sfr@canb.auug.org.au>
	 <1245078707.3858.0.camel@mulgrave.site> <1245102000.12400.44.camel@pasglop>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 22:24:37 -0400
Message-Id: <1245119077.3858.51.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 07:40 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-15 at 10:11 -0500, James Bottomley wrote:
> > OK, dumped the offending patch, so it should be safe to take scsi-misc
> > again.
> > 
> > I'm so used to merging these type of conversions, I didn't check that
> > it
> > was using a ps3 specific wrapper instead of a generic device one.
> 
> Do I have your Ack to merge the patch via the powerpc tree ?

Ack

James


