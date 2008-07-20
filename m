Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYGTUs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYGTUs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 16:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYGTUsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 16:48:51 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:45415 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYGTUsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 16:48:51 -0400
Message-ID: <4883A4BB.1020803@dolphinics.no>
Date: Sun, 20 Jul 2008 22:48:59 +0200
From: Simen Timian Thoresen <simentt@dolphinics.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Misidentification and failing revalidations of ide dvd-roms with
 libata
References: <48838593.8020007@dolphinics.no> <20080720194628.6c8632cb@the-village.bc.nu> <48839358.8010206@dolphinics.no> <200807202103.51889.alistair@devzero.co.uk>
In-Reply-To: <200807202103.51889.alistair@devzero.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Sunday 20 July 2008 20:34:48 Simen Timian Thoresen wrote:
>> Alan Cox wrote:
>>>> [  155.457098] ata4.00: model number mismatch 'Pioneer DVD-ROM
>>>> ATAPIModel DVD-116  0109' != 'Pioïeer¡DVD­ROM¡ATAñIMoåel åVD-±16 ¡010¹'
>>>> [  155.457103] ata4.00: revalidation failed (errno=-19)
>>> So it failed because the data read from the drive was corrupted.
>>>
> 
> Power supply maybe? Check the rails. The +12VDC must be good.
> 
Hi Alistair,

Good suggestion - I've rebooted and am running the box with one of the 
DVDroms connected to an external PSU. I'd now expect the one on the 
internal rail to be the failing one, if either fails.

I'm done ripping CDs for now, but I'm checking to see if I can trigger 
the same ripping DVDs.

Yours,
-S

-- 
Simen Thoresen, Dolphin ICS
Systems Administration and Wulfkit Support

