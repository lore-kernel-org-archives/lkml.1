Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbXI2GVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbXI2GVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 02:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXI2GV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 02:21:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56242 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752702AbXI2GV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 02:21:28 -0400
Date: Sat, 29 Sep 2007 07:26:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Carr <bcarr@whoi.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Sandeen <sandeen@sandeen.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: Truncated Filesystem
Message-ID: <20070929072653.4e706888@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
	<Pine.LNX.4.64.0709281821390.12203@p34.internal.lan>
	<46FD9006.6050807@sandeen.net>
	<46FD959E.5030009@zytor.com>
	<Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 20:49:12 -0400 (EDT)
Benjamin Carr <bcarr@whoi.edu> wrote:

> > What kind of partition table is it?  MS-DOS partition tables have a 2 TB
> > limit.
> 
> Hadn't thought of that, doesn't look good.
> -Ben
> 
> sudo fdisk -l /dev/sdc1
> benc's password:

That would be on /dev/sdc surely ?
