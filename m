Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab0BQHeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 02:34:14 -0500
Received: from swm.pp.se ([212.247.200.143]:50093 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933934Ab0BQHeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 02:34:12 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2010 02:34:11 EST
Date: Wed, 17 Feb 2010 08:27:39 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Jeff Garzik <jeff@garzik.org>
cc: The Government <the_g0vernment@yahoo.com>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: sata_mv driver support for Marvell Hercules II controller in
 newer kernels
In-Reply-To: <4B7B9241.9070101@garzik.org>
Message-ID: <alpine.DEB.1.10.1002170825370.28940@uplift.swm.pp.se>
References: <549084.45576.qm@web45206.mail.sp1.yahoo.com> <4B7B9241.9070101@garzik.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, Jeff Garzik wrote:

> On 02/16/2010 10:44 PM, The Government wrote:
>> Hey guys,
>> 
>> I'm using a Supermicro aoc-sat2-mv8, which is supposedly supported by the 
>> Linux kernel by "sata_mv" driver. Unfortunately, I've been unable to 
>> troubleshoot why newer distros (and thus kernels) are not detecting/using 
>> sata_mv for this card. I tried an (older) Slackware 12.1 install disk, that 
>> for some reason works by use of sata_mv (12.1 was released may 2008, when I 
>> think sata_mv was still beta). Anyhow, I've tried many newest releases from 
>> Slackware, Arch, etc - and it seems newer kernels do not properly recognize 
>> this card. I'm not sure what to make of the newer kernels saying "adaptec 
>> aacraid driver" is being used (an incorrectly detected driver?). Anyway, I 
>> was told this chipset had great linux support - does it still? Thanks a 
>> lot.
>> 
>> (please CC me for replies, thanks a lot)
>
> (cc linux-ide added)
>
> We need a lot more hard detail, such as lspci and dmesg output.

Hi,

the aoc-sat2-mv8 is properly recognised and used (sata_mv) in Ubuntu 10.04 
anyway (2.6.32) so it's not strictly a kernel issue.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
