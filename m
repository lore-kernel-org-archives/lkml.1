Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbYLNPKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbYLNPKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 10:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYLNPKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 10:10:22 -0500
Received: from sov-mail-b0014.gradwell.net ([193.84.87.38]:52203 "EHLO
	sov-mail-b0014.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbYLNPKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 10:10:21 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Dec 2008 10:10:20 EST
Date: Sun, 14 Dec 2008 15:03:10 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: SiI 3112 support in kernel 2.6.27
Message-ID: <20081214150310.374f1de2@lithium.local.net>
In-Reply-To: <49451B63.9040400@asyr.hopto.org>
References: <49451B63.9040400@asyr.hopto.org>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2008 16:42:43 +0200, I waved a wand and this message
magically appears in front of Thanasis:

> Q: In order to support the SiI 3112 (PCMCIA) controller, what module
> (or built in option) should be set for kernel version 2.6.27?

Build the sata_sil module.
-- 
http://www.munted.org.uk

Fearsome grindings.
