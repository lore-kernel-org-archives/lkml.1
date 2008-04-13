Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYDMNeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYDMNeC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 09:34:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbYDMNdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 09:33:51 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:62492 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbYDMNdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 09:33:51 -0400
Message-ID: <fa686aa40804130633p49be1e12sdbd14e5efd1bdf68@mail.gmail.com>
Date: Sun, 13 Apr 2008 07:33:49 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: monstr@seznam.cz
Subject: Re: Microblaze Linux release
Cc: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>,
       "John Williams" <john.williams@petalogix.com>,
       jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org,
       "John Linn" <John.Linn@xilinx.com>, git-dev@xilinx.com, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       paulus@samba.org
In-Reply-To: <48020A21.4000404@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48020A21.4000404@seznam.cz>
X-Google-Sender-Auth: 45e93c57457c8c43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 7:26 AM, Michal Simek <monstr@seznam.cz> wrote:
> Hi Everybody,
>
>  I fixed all reported bugs which I got from LKML and from you.
>  Latest version of Microblaze Linux kernel is available at git.monstr.eu.
>  There is git repository called linux-microblaze.git
>  Microblaze port is based on 2.6.24-rc5. I'll create the new repo with clean pack
>  of changes based on latest kernel version for easier pull.
>
>  Merge windows will be open hopefully next week and I would like to send pull
>  request to Paul.
>
>  I would like to ask you for review all microblaze code especially
>  arch/microblaze and include/asm-microblaze. Please don't send me question to
>  drivers - Microblaze will use only uartlite driver (only add on or to Kconfig -
>  that's enough for now).

Can you please also post your updated patch series?  Reviewing patches
is easy.  Reviewing a git tree is a lot more work.

Thanks,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
