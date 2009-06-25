Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZFYFXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZFYFXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZFYFXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:23:34 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:49107 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZFYFXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:23:33 -0400
Message-ID: <4A4309B0.7020400@mellanox.co.il>
Date: Thu, 25 Jun 2009 08:22:56 +0300
From: Tziporet Koren <tziporet@dev.mellanox.co.il>
Reply-To: tziporet@dev.mellanox.co.il
Organization: Mellanox Technologies
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] [GIT PULL] please pull infiniband.git
References: <adad48uq26w.fsf@cisco.com>
In-Reply-To: <adad48uq26w.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Linus, please pull from
>
>     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
>
> This tree is also available from kernel.org mirrors at:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
>
> This has a few more fixes for 2.6.31-rc1; however everything here
> should be a fix appropriate for -rc2 as well, so if this misses the
> end of the merge window then I think it should still be OK to pull.
>
>   

Roland
What about the patches from Yevgeny supporting our new ConnextX HW 
coming soon?

I talk about:
http://lists.openfabrics.org/pipermail/general/2009-June/060225.html
http://lists.openfabrics.org/pipermail/general/2009-June/060226.html

Since device ID is already in pci.ids I think it is important to have 
this code too, otherwise the driver will not load :-(

Thanks
Tziporet


