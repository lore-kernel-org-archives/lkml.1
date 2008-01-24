Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYAXBLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYAXBLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 20:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYAXBLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 20:11:15 -0500
Received: from mail.vyatta.com ([216.93.170.194]:59302 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbYAXBLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 20:11:14 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.599
Date: Wed, 23 Jan 2008 17:07:48 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Tobias Winter <tobias@linuxdingsda.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel bug report 2.6.24-rc8 on core2quad q6600 with debian
 unstable amd64
Message-ID: <20080123170748.36068472@deepthought>
In-Reply-To: <4797D86B.3060202@linuxdingsda.de>
References: <4797D86B.3060202@linuxdingsda.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008 01:14:35 +0100
Tobias Winter <tobias@linuxdingsda.de> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> Hi folks, I'm sending the bug report here, since i have no idea where
> else to send it. I hope it is helping.
> 
> 
> [1.] One line summary of the problem:
> The kernel panics under high CPU/IO load, compilers segfault, mdadm
> used to do so, too.
> 
> [2.] Full description of the problem/report:
> I upgraded my system to fairly new hardware and find myself unable to
> compile any kernel source and the system panics under high load e.g.
> resyncing a RAID or building a kernel. Building kernel is 100% sure to
> result in a kernel panic.

Sounds like bad memory. Run memtest for at least 24hrs.
