Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZBYRx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZBYRx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZBYRxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:53:19 -0500
Received: from sov-mail-b0012.gradwell.net ([193.84.87.36]:44106 "EHLO
	sov-mail-b0012.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbZBYRxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:53:18 -0500
Date: Wed, 25 Feb 2009 17:52:49 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Unused modules in 2.6.x
Message-ID: <20090225175249.30e47b85@lithium.local.net>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Perhaps I missed something when the 2.6.x kernels got started a few
years back, but why is it not possible for unused modules to be
automatically unloaded anymore i.e with rmmod -a? I remember being able
to do that with the 2.2.x and 2.4.x series a long time ago.


Thanks,
Alex
-- 
http://www.munted.org.uk

Fearsome grindings.
