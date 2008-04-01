Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbYDAViA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbYDAViA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760244AbYDAVhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:37:37 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:45758 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbYDAVhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:37:36 -0400
Message-ID: <47F2AADF.1070705@freescale.com>
Date: Tue, 01 Apr 2008 16:36:31 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: York Sun <yorksun@freescale.com>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org, a.p.zijlstra@chello.nl,
       scottwood@freescale.com, avorontsov@ru.mvista.com
Subject: Re: [PATCH 2/2 v5] Add DIU platform code for MPC8610HPCD
References: <12069806051060-git-send-email-yorksun@freescale.com>	<1206980605689-git-send-email-yorksun@freescale.com>	<12069806051291-git-send-email-yorksun@freescale.com> <20080401140029.be918d87.akpm@linux-foundation.org>
In-Reply-To: <20080401140029.be918d87.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> The defconfig change gets almost 100% rejects and probably isn't
> appropriate here and isn't very important.

It's weird that you get rejects, but otherwise you're correct.  defconfigs are
just a convenience, anyway.

-- 
Timur Tabi
Linux kernel developer at Freescale
