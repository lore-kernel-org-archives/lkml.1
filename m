Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbXI2BGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbXI2BGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 21:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbXI2BG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 21:06:28 -0400
Received: from zeratul.whoi.edu ([128.128.76.62]:54861 "EHLO mx1.whoi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757999AbXI2BG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 21:06:27 -0400
X-Greylist: delayed 1031 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 21:06:26 EDT
Date: Fri, 28 Sep 2007 21:06:22 -0400 (EDT)
From: Benjamin Carr <bcarr@whoi.edu>
X-X-Sender: benc@puck.litech.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: Truncated Filesystem
In-Reply-To: <46FDA35A.8040504@zytor.com>
Message-ID: <Pine.LNX.4.58.0709282105590.14057@puck.litech.org>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
 <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net>
 <46FD959E.5030009@zytor.com> <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
 <46FDA35A.8040504@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > sudo fdisk -l /dev/sdc1
>                 ^^^^^^^^^ Uh...

yeah, long day:

Disk /dev/sdc: 12999.9 GB, 12999988871168 bytes
255 heads, 63 sectors/track, 1580491 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      243744  1957867653+  83  Linux

