Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZGBKc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZGBKc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZGBKct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:32:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43515 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753193AbZGBKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:32:48 -0400
Date: Thu, 2 Jul 2009 11:33:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702113351.41037d87@lxorguk.ukuu.org.uk>
In-Reply-To: <19020.4239.587690.363822@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<20090701151727.38928bd9@lxorguk.ukuu.org.uk>
	<19020.4239.587690.363822@samba.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 11:42:39 +1000
tridge@samba.org wrote:

> Hi Alan,
> 
>  > > There really was no such thing as "vfat" anyway.  VFAT in the Windows
>  > 
>  > In the eyes of the end user there is such a thing as vfat. This is about
>  > expectations not technical issues.
> 
> Do you have an example of an end user device that would be affected by
> this change, and which is never distributed in any of the countries
> where a varient of this patent exists?

You gave one: Microsoft Windows XP. Risk of very rare system crashes.

Thats enough in a high reliability environment to require the file system
in question is banned from use site wide at may locations. Can't have a
flash card bringing down a windows dependant US destroyer can they.

Getting "not vfat" by suprise is thus really really bad
