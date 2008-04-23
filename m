Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbYDWGsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbYDWGsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYDWGsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:48:10 -0400
Received: from mr1.bfh.ch ([147.87.250.50]:49705 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYDWGsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:48:08 -0400
Message-ID: <480EDBA2.5000506@bfh.ch>
Date: Wed, 23 Apr 2008 08:48:02 +0200
From: Seewer Philippe <philippe.seewer@bfh.ch>
Organization: BFH
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>	 <480354C9.1050600@bfh.ch>	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>	 <4805AF93.90209@bfh.ch>	 <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>	 <4807635E.9060101@bfh.ch> <38b2ab8a0804221310h6fdb9346q280f75ca2b85ff18@mail.gmail.com>
In-Reply-To: <38b2ab8a0804221310h6fdb9346q280f75ca2b85ff18@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Apr 2008 06:47:43.0720 (UTC) FILETIME=[EEA7EE80:01C8A50D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
[snip]
> Just out of curiosity, what does scsi use for addressing IO operations ?
I'm quoting from http://www.mossywell.com/boot-sequence/
[quote]
LBA has been around since around 1981. It is the method used to access 
SCSI drives. However, in the mid-1990s IDE disks finally caught up with 
SCSI and started to use LBA as well.
[/quote]

Further Information is provided by wikipedia as well:
http://en.wikipedia.org/wiki/SCSI
http://en.wikipedia.org/wiki/Logical_block_addressing

Have fun!
Philippe Seewer
