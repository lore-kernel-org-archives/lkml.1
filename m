Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbXF3JJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbXF3JJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXF3JJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:09:19 -0400
Received: from [84.243.56.243] ([84.243.56.243]:51385 "EHLO aurora.bayour.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXF3JJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:09:18 -0400
From: Turbo Fredriksson <turbo@bayour.com>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Moving MD/LVM from PPC to x86
Organization: Bah!
References: <87wsxneqs0.fsf@pumba.bayour.com>
	<20070629215416.GA12786@agk.fab.redhat.com>
X-PGP-Fingerprint: B7 92 93 0E 06 94 D6 22  98 1F 0B 5B FE 33 A1 0B
X-PGP-Key-ID: 0x788CD1A9
X-URL: http://www.bayour.com/
Date: Sat, 30 Jun 2007 11:09:15 +0200
In-Reply-To: <20070629215416.GA12786@agk.fab.redhat.com> (Alasdair G. Kergon's
	message of "Fri, 29 Jun 2007 22:54:16 +0100")
Message-ID: <876455erlw.fsf@pumba.bayour.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alasdair G Kergon <agk@redhat.com>:

> On Thu, Jun 28, 2007 at 11:02:39PM +0200, Turbo Fredriksson wrote:
>>   2. How do I move a VG/PV/LV from PPC to x86?
>
> The on-disk LVM2 metadata should be accessible from both
> architectures.

Well, when I move the disks, the intel machine say that one of
the disks don't have a partition table and that the other don't
have any MD superblock...
