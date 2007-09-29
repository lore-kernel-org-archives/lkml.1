Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbXI2BQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbXI2BQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 21:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbXI2BQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 21:16:37 -0400
Received: from zeratul.whoi.edu ([128.128.76.62]:55091 "EHLO mx1.whoi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbXI2BQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 21:16:36 -0400
Date: Fri, 28 Sep 2007 20:49:12 -0400 (EDT)
From: Benjamin Carr <bcarr@whoi.edu>
X-X-Sender: benc@puck.litech.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: Truncated Filesystem
In-Reply-To: <46FD959E.5030009@zytor.com>
Message-ID: <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
 <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net>
 <46FD959E.5030009@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What kind of partition table is it?  MS-DOS partition tables have a 2 TB
> limit.

Hadn't thought of that, doesn't look good.
-Ben

sudo fdisk -l /dev/sdc1
benc's password:

Disk /dev/sdc1: 2004.8 GB, 2004856477184 bytes
255 heads, 63 sectors/track, 243743 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sdc1 doesn't contain a valid partition table

