Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbXGWLA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbXGWLA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbXGWLAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:00:12 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21602 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537AbXGWLAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:00:11 -0400
Message-ID: <46A48A38.9030803@msgid.tls.msk.ru>
Date: Mon, 23 Jul 2007 15:00:08 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: BuraphaLinux Server <buraphalinuxserver@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SCSI vs SATA
References: <5d75f4610707230352j69b2ba53g1564e420fc64ea49@mail.gmail.com>
In-Reply-To: <5d75f4610707230352j69b2ba53g1564e420fc64ea49@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BuraphaLinux Server wrote:
> Hello,
> 
>    I have had a hard time determining if /dev/sda is SCSI or SATA
> from my boot scripts.  It matters for smartd which needs an added
> parameter -d sat in the configuration file for SATA drives.  Finally I

Just FYI:  Recent smartmontools (5.36+) can figure this out automagically.

/mjt
