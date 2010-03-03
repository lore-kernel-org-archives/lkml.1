Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0CCPvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:51:01 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44696 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab0CCPu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:50:59 -0500
Date: Wed, 3 Mar 2010 16:51:10 +0100
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Thompson <norsk5@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac fix for .34
Message-ID: <20100303155110.GA18681@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following fix for .34.

Thanks.

The following changes since commit 60b341b778cc2929df16c0a504c91621b3c6a4ad:
  Linus Torvalds (1):
        Linux 2.6.33

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (1):
      amd64_edac: Simplify ECC override handling

 drivers/edac/amd64_edac.c |   37 +++++++++++++++++++------------------
 drivers/edac/amd64_edac.h |    3 ++-
 2 files changed, 21 insertions(+), 19 deletions(-)

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
