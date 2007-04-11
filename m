Return-Path: <linux-kernel-owner+w=401wt.eu-S1750968AbXDKHhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbXDKHhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXDKHhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:37:11 -0400
Received: from mail.gatrixx.com ([217.111.11.44]:31268 "EHLO mail.gatrixx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbXDKHhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:37:09 -0400
Message-ID: <461C9014.6040109@j-o-a.de>
Date: Wed, 11 Apr 2007 09:36:52 +0200
From: Oliver Joa <oliver@j-o-a.de>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: xfs-oss <xfs@oss.sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de> <20070328113141.GQ32597093@melbourne.sgi.com>
In-Reply-To: <20070328113141.GQ32597093@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Chinner wrote:
> On Tue, Mar 27, 2007 at 06:16:04PM +0200, Oliver Joa wrote:
>> Hi,
>>
>> since some weeks i try to get my new hardware running:
>>
>> Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
>> Intel DP965LT Mainboard
>> Seagate SATA-Harddisk in AHCI-Mode
>>
>> After some hours of running or after some heavy file-i/o
>> (find / | cpio -padm /test) I always get a corrupted
>> XFS-filesystem.

I solved the problem: I made a memtest and found a lot of memory-errors, 
then i bought a other brand of memory and everything working fine. The 
first memory i used was brandnew. I bought it together with the board 
and processor. It was from Kingston. Now i have one from Crucial, which 
seems to work fine.

Thanks to everyone for the help

Olli
