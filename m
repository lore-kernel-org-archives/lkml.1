Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbZD3Hej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbZD3Hej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZD3Hea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:34:30 -0400
Received: from sov-mail-b0016.gradwell.net ([193.84.87.40]:57192 "EHLO
	sov-mail-b0016.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbZD3Hea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:34:30 -0400
Date: Thu, 30 Apr 2009 08:33:09 +0100
From: Alex Buell <alex.buell@munted.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
 question)
Message-ID: <20090430083309.437f9248@lithium.local.net>
In-Reply-To: <49F90CA2.4080602@garzik.org>
References: <E1LzLgA-0004j6-9W@closure.thunk.org>
	<49F90CA2.4080602@garzik.org>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 22:27:46 -0400, I waved a wand and this message
magically appears in front of Jeff Garzik:

> As Tejun noted, try switching to AHCI mode in BIOS.

But is there a way to switch modes without needing to go through the
BIOS? Some laptops won't let you do that through BIOS. 
-- 
http://www.munted.org.uk

Fearsome grindings.
