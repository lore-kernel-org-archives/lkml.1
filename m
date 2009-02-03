Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZBCOy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZBCOy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZBCOyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:54:47 -0500
Received: from sov-mail-b0010.gradwell.net ([193.84.87.34]:40282 "EHLO
	sov-mail-b0010.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbZBCOyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:54:46 -0500
Date: Tue, 3 Feb 2009 14:54:01 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27 & ext4 strangeness
Message-ID: <20090203145401.08af7fe8@lithium.local.net>
In-Reply-To: <20090131000917.GB27950@mit.edu>
References: <20090130194702.5a2ca774@lithium.local.net>
	<20090131000917.GB27950@mit.edu>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 19:09:17 -0500, I waved a wand and this message
magically appears in front of Theodore Tso:

> If you can reproduce this, can you send me the output of "df /; df -i
> /; dumpe2fs /dev/XXX" (where XXX is your root device) before you
> reboot and force an fsck?  And then can you send me the output of "df
> / ; df -i /; dumpe2fs /dev/XXX" after the 2nd reboot and forced fsck.
> I've never seen anything like this, so I don't know what to make of
> it.
> 
> It also would be interesting to see if you can reproduce it running a
> kernel from the ext4-stable branch of the ext4 tree:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
>    http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git
> 
> This has all of the ext4 fixes that is in the latest mainline, based
> on the 2.6.28 kernel.

I've not been able to reproduce this yet but when it happens again I
will drop you a email. I'm actually quite happy with ext4 ever since I
switched all my boxes over to that filesystem. 

Thanks.
-- 
http://www.munted.org.uk

Fearsome grindings.
