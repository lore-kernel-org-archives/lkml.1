Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbZBLAf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbZBLAf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 19:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZBLAfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 19:35:19 -0500
Received: from sh-spam-4.gradwell.net ([193.84.87.110]:33224 "EHLO
	sh-spam-4.gradwell.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbZBLAfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:35:17 -0500
Date: Thu, 12 Feb 2009 00:35:05 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>, Ed Cashin <ecashin@coraid.com>,
       linux-kernel@vger.kernel.org, karaluh@karaluh.pl
Subject: Re: [PATCH 1/1] aoe: ignore vendor extension AoE responses
Message-ID: <20090212003505.727354e9@lithium.local.net>
In-Reply-To: <20090211162944.c1cdf8fb.akpm@linux-foundation.org>
References: <1234397804-9034-1-git-send-email-ecashin@coraid.com>
	<20090211162944.c1cdf8fb.akpm@linux-foundation.org>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 16:29:44 -0800, I waved a wand and this message
magically appears in front of Andrew Morton:

> Do you believe that this fix should be backported into earlier kernel
> versions?  (2.6.28.x, 2.6.27.x, etc)

Yes, please - I'll be using AoE on these kernels. It might also be a
good opportunity to update the AoE module, as I believe the latest out
of the kernel tree module is currently at 70, whilst the version in
2.6.27 is at 47.
-- 
http://www.munted.org.uk

Fearsome grindings.
.
