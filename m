Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbZHUPm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbZHUPm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbZHUPm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:42:56 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:63267 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbZHUPm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:42:56 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: AMD K10 temp.module ready since months, but missing in kernel...
Date: Fri, 21 Aug 2009 11:42:42 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6; KDE/4.2.4; i686; ; )
Cc: mmi@superbash.de, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>, r.marek@assembler.cz
References: <20090821001322.470bb177@p4laptop>
 <20090821104533.GA3872@liondog.tnic>
In-reply-to: <20090821104533.GA3872@liondog.tnic>
MIME-version: 1.0
Content-type: Text/Plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200908211142.42922.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 August 2009, Borislav Petkov wrote:
>[ adding relevant CCs ]
>
>On Fri, Aug 21, 2009 at 12:13:22AM +0200, mmi wrote:
>> Hello out there,
>>
>> i found the code to read temperature of AMD K10 (Phenom) processors a
>> couple of months ago in the net (GPL). I use it since January now and i
>> wonder, why it's not in the kernel till now.
>>
>> It's from the same author, who wrote k8temp.c (which is in kernel).
>>
>> Thanks,
>>
>> M. Miederer

Butting in on the thread:
And I would like this to get in very much.  Not even gkrellm seems to be able 
to read my phenom since about 2.6.30.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

It's ten o'clock. Do you know where your source code is?

