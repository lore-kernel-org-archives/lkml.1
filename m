Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbYBXURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbYBXURl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 15:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYBXURc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 15:17:32 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52727 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYBXURb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 15:17:31 -0500
Date: Sun, 24 Feb 2008 22:16:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: robert@schwebel.de,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Martin J. Bligh" <mbligh@aracnet.com>, pazke@donpac.ru,
       florian.fainelli@telecomint.eu,
       Ravikiran Thirumalai <kiran@scalemp.com>,
       Shai Fultheim <shai@scalemp.com>
Cc: linux-kernel@vger.kernel.org, linux-visws-devel@lists.sourceforge.net
Subject: defconfig's for all x86 subarchitectures
Message-ID: <20080224201634.GD1596@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For compile tests it would be nice it we had at least for each 
subarchitecture not covered by X86_GENERICARCH a defconfig.

These are the following subarchitectures:
- X86_ELAN
- X86_VOYAGER
- X86_NUMAQ
- X86_VISWS
- X86_RDC321X
- X86_VSMP

A defconfig is nothing special, it's enough to simply put the .config 
used for one machine into arch/x86/configs/ .

Thanks in advance
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

