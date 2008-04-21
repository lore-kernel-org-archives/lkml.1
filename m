Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYDUNlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYDUNlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932174AbYDUNka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:40:30 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:42932 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760380AbYDUNk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:40:28 -0400
Message-ID: <480C994A.1060406@blueyonder.co.uk>
Date: Mon, 21 Apr 2008 14:40:26 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 3.0a1pre (X11/2007120104)
MIME-Version: 1.0
To: Marc Dionne <marc.c.dionne@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2 (swap)
 partitions on a SATA drive
References: <480A9C1E.8050505@blueyonder.co.uk>	 <20080420112549.GB4902@martell.zuzino.mipt.ru>	 <480B3958.9010708@blueyonder.co.uk> <6041d2000804210454t4c83de95td9bfd85c98de80b6@mail.gmail.com>
In-Reply-To: <6041d2000804210454t4c83de95td9bfd85c98de80b6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Dionne wrote:
> On Sun, Apr 20, 2008 at 8:38 AM, Sid Boyce <g3vbv@blueyonder.co.uk> wrote:
>>>> 2.6.25 x86_64 boots fine as does -git1/2 boxes using reiserfs and ext3.
>>>> With xfs it can't find these and drops into a shell.
>>>> /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part2 swap
>>>>      swap       defaults              0 0
>>>> /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 /
>>>>   xfs        defaults              1 1
>>>>
>>>> 00:0c.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
>>>> 00:0d.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
>>>> 00:0d.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
>>>> 00:0d.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
>>>> 03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA
>>>> Raid II Controller (rev 01)
> 
> Perhaps related to these threads ?
>     http://marc.info/?l=linux-ide&m=120866699221716
The one above seems close to what I experience.

>     http://marc.info/?l=linux-scsi&m=120854308421912
The patch is already mainstream.
> 
> Marc
> 
> 
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

