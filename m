Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYDMN1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYDMN1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 09:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbYDMN1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 09:27:00 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:52760 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755571AbYDMN07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 09:26:59 -0400
Message-ID: <48020A21.4000404@seznam.cz>
Date: Sun, 13 Apr 2008 15:26:57 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, Grant Likely <grant.likely@secretlab.ca>,
       git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Microblaze Linux release
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everybody,

I fixed all reported bugs which I got from LKML and from you.
Latest version of Microblaze Linux kernel is available at git.monstr.eu.
There is git repository called linux-microblaze.git
Microblaze port is based on 2.6.24-rc5. I'll create the new repo with clean pack
of changes based on latest kernel version for easier pull.

Merge windows will be open hopefully next week and I would like to send pull
request to Paul.

I would like to ask you for review all microblaze code especially
arch/microblaze and include/asm-microblaze. Please don't send me question to
drivers - Microblaze will use only uartlite driver (only add on or to Kconfig -
that's enough for now).

All questions and reported bug please send to me.
Please report all bugs (coding style, long line, poor coments - everything).
Please send me your ACK too. For my better summary - please send me list of
files. Summary will be continuously concurrently publish at
http://www.monstr.eu/wiki/doku.php?id=kernel:kernel.


Thanks for your help,

Michal Simek,
www.monstr.eu

P.S.: For LKML users - I am going to integrate all bugs to previous set of
patches - that's why I asked about how to do it. I hope I send this pack today
or on Monday.

