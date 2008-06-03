Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYFCLrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYFCLrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYFCLrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:47:25 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39528 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbYFCLrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:47:25 -0400
Date: Tue, 3 Jun 2008 13:47:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Mike White <argentia@operamail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel GPF ACPI
In-Reply-To: <20080603021645.A63FDCBC9E@ws5-11.us4.outblaze.com>
Message-ID: <Pine.LNX.4.64.0806031345190.1716@twin.jikos.cz>
References: <20080603021645.A63FDCBC9E@ws5-11.us4.outblaze.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, Mike White wrote:

> Running Opensuse 10.3 on Asus M2N32-SLI (default BIOS settings), AMD Dual core CPU.
> Kernel is stock that comes with that version of suse.
> Linux deathscape 2.6.22.5-31-default #1 SMP 2007/09/21 22:29:00 UTC x86_64 x86_64 x86_64 GNU/Linux
> Upon booting the system, service /etc/rc.d/powersaved segfaults, specifically /usr/sbin/powersaved
> Output from dmesg:
> Jun  2 00:51:01 deathscape kernel: general protection fault: 0000 [1] SMP 

This is not a vanilla kernel, but a kernel with distro-specific patches, 
please report this through your distro bugzilla.

Thanks,

-- 
Jiri Kosina
SUSE Labs

