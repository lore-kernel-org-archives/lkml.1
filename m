Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbZDHLJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbZDHLJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZDHLJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:09:30 -0400
Received: from sov-mail-b0016.gradwell.net ([193.84.87.40]:47756 "EHLO
	sov-mail-b0016.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264AbZDHLJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:09:29 -0400
Date: Wed, 8 Apr 2009 12:08:36 +0100
From: Alex Buell <alex.buell@munted.org.uk>
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090408120836.45d8b326@lithium.local.net>
In-Reply-To: <20090408003921.GA5054@ldl.fc.hp.com>
References: <20090408003921.GA5054@ldl.fc.hp.com>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 18:39:21 -0600, I waved a wand and this message
magically appears in front of Alex Chiang:

> I've been using your cross-compilers here:
> 
> 	http://userweb.kernel.org/~akpm/cross-compilers/
> 
> for a long time now, but they're starting to suffer from a bit of
> neglect.

Why bother? 

You can use 'crossdev' to build your own cross-compilers instead. They
can build either stable or unstable toolchains for your target
architectures. 
-- 
http://www.munted.org.uk

Fearsome grindings.
