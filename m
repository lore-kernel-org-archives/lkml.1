Return-Path: <linux-kernel-owner+w=401wt.eu-S1764303AbYEFPXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764303AbYEFPXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbYEFPXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:23:00 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:56165 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756706AbYEFPW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:22:59 -0400
Message-ID: <482077FE.7080201@seznam.cz>
Date: Tue, 06 May 2008 17:23:42 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: John Williams <john.williams@petalogix.com>, monstr@seznam.cz,
       linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca
Subject: Re: [PATCH 45/56] microblaze_v2: headers simple files - empty or
 redirect to asm-generic
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	<96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>	<92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>	<4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>	<49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>	<d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>	<27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>	<64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>	<9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>	<5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>	<59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>	<8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>	<1209954849.5798.80.camel@localhost> <20080507004702.d516a727.sfr@canb.auug.org.au>
In-Reply-To: <20080507004702.d516a727.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Mon, 05 May 2008 12:34:09 +1000 John Williams <john.williams@petalogix.com> wrote:
>>
>>>  include/asm-microblaze/auxvec.h            |   14 ++++++++++++++
>>>  include/asm-microblaze/cputime.h           |   16 ++++++++++++++++
>>>  include/asm-microblaze/div64.h             |   16 ++++++++++++++++
>>>  include/asm-microblaze/emergency-restart.h |   16 ++++++++++++++++
>>>  include/asm-microblaze/errno.h             |   16 ++++++++++++++++
>>>  include/asm-microblaze/futex.h             |   16 ++++++++++++++++
>>>  include/asm-microblaze/kdebug.h            |   19 +++++++++++++++++++
>>>  include/asm-microblaze/local.h             |   16 ++++++++++++++++
>>>  include/asm-microblaze/mutex.h             |   16 ++++++++++++++++
>>>  include/asm-microblaze/namei.h             |   24 ++++++++++++++++++++++++
>>>  include/asm-microblaze/percpu.h            |   16 ++++++++++++++++
>>>  include/asm-microblaze/resource.h          |   16 ++++++++++++++++
>>>  include/asm-microblaze/user.h              |   18 ++++++++++++++++++
>> These are all just includes of asm-generic/* (hooray!).
> 
> Absolutely, but is it really necessary to have 14-16 lines of comment
> (including a copyright notice) for a file whose single real line is just
> to include another file?  i.e. reduce all these to 1 line files.

Can I do it? I think every file need license.

M
