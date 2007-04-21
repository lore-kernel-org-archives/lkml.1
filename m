Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXDUTpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXDUTpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXDUTpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:45:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbXDUTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:45:06 -0400
Date: Sat, 21 Apr 2007 12:43:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Sunil Naidu" <akula2.shark@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Greg KH" <gregkh@suse.de>,
       stable@kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Linux 2.6.20.7 - Hard Disk rumbling?
Message-Id: <20070421124345.1f9b63fa.akpm@linux-foundation.org>
In-Reply-To: <8355959a0704210658j3b54a8cfl8a8a73661cd50c9d@mail.gmail.com>
References: <8355959a0704210658j3b54a8cfl8a8a73661cd50c9d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007 19:28:30 +0530 "Sunil Naidu" <akula2.shark@gmail.com> wrote:

> Hello,
> 
> I am facing a strange problems with an old 1.2 GHz P-III machine with
> a 10 GB disk (used as a dedicated web server, later retired out of
> service!).
> 
> Out of interest to implement some wireless solution (experiment), I
> did compile 2.6.20.7 for my requirement. Strangely, I did observe:-
> 
> hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
> hda: drive_cmd: error=0x04 { DriveStatusError }
> ide: failed opcode was: 0xb0
> 
> What might be the problem?
> 

So the machine is OK with an earlier kernel version?  If so, which version?

Please send the full log from attempting to boot 2.6.20.7 on that machine.  This
might require netconsole or serial console.

Thanks.
