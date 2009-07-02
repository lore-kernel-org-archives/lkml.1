Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZGBMnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZGBMnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZGBMnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:43:32 -0400
Received: from mail.samba.org ([66.70.73.150]:50045 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbZGBMnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:43:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19020.43882.457869.346115@samba.org>
Date: Thu, 2 Jul 2009 22:43:22 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090702113351.41037d87@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<20090701151727.38928bd9@lxorguk.ukuu.org.uk>
	<19020.4239.587690.363822@samba.org>
	<20090702113351.41037d87@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > You gave one: Microsoft Windows XP. Risk of very rare system crashes.
 > 
 > Thats enough in a high reliability environment to require the file system
 > in question is banned from use site wide at may locations. Can't have a
 > flash card bringing down a windows dependant US destroyer can they.

I think it could indeed be very wise not to insert FAT removable media
into 'high reliability' WindowsXP machines, but not because of the
patch I've proposed. A prudent IT manager might take a look at how
many fastfat.sys crashes are being reported on WindowsXP and realise
that viewing ones holiday photos on your heart bypass machine isn't a
great idea :-)

Cheers, Tridge
