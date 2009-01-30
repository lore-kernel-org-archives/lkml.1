Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZA3TrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZA3TrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZA3TrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:47:14 -0500
Received: from sov-mail-b0017.gradwell.net ([193.84.87.41]:45071 "EHLO
	sov-mail-b0017.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbZA3TrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:47:13 -0500
Date: Fri, 30 Jan 2009 19:47:02 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Fw: 2.6.27 & ext4 strangeness
Message-ID: <20090130194702.5a2ca774@lithium.local.net>
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

As this has happened three times in the last 24 hours, I thought I'd
report this. Whenever my laptop locks up, I have to powercycle. After
rebooting, and fsck.ext4 reports a clean filesystem, often I get a 'no
space on device' error even though I have plenty of disk space left.
Another reboot with a forced fsck.ext4 cures this, every time. This only
happens with ext4 filesystems used as the root filesystem. 
-- 
http://www.munted.org.uk

Fearsome grindings.
