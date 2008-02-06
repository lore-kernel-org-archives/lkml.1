Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbYBFDDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbYBFDDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 22:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYBFDDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 22:03:25 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:53029 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbYBFDDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 22:03:24 -0500
Date: Tue, 5 Feb 2008 19:02:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pekka Paalanen <pq@iki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86 mmiotrace: move files into arch/x86/mm/
Message-Id: <20080205190200.1f9784a9.randy.dunlap@oracle.com>
In-Reply-To: <20080205223958.2cab8ce3@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131081507.5edcde10@laptopd505.fenrus.org>
	<20080203085522.2b63e15b@daedalus.pq.iki.fi>
	<20080203070321.GA8293@elte.hu>
	<20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	<20080205223958.2cab8ce3@daedalus.pq.iki.fi>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 22:39:58 +0200 Pekka Paalanen wrote:

> As this patch is too big for the list, it can be found at:
> http://jumi.lut.fi/~paalanen/scratch/mmio25-b/0004-x86-mmiotrace-move-files-into-arch-x86-mm.patch
> 
> The patch is 85 kB and Documentation/SubmittingPatches says I should not
> post it to the list if it exceeds 40 kB.

Hm, we need to change that comment. The mailing list limit
(for lkml) is now 400 KB AFAIK.  Certainly we see plenty of
patches that are larger than 40 KB.

> Ingo, I can also send this directly to your email, if you wish.

Please email it to the mailing list.

---
~Randy
