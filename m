Return-Path: <linux-kernel-owner+w=401wt.eu-S1765271AbZLQSFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765271AbZLQSFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765007AbZLQSFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:05:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60249 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbZLQSFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:05:20 -0500
To: device-mapper development <dm-devel@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
	<200912171708.07899.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
Date: Thu, 17 Dec 2009 19:05:18 +0100
In-Reply-To: <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain> (Linus Torvalds's message of "Thu, 17 Dec 2009 08:21:10 -0800 (PST)")
Message-ID: <874onptr1d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:


> fixed that to allow checkpatch to skip those warnings, but the fact is, 
> the fundamnetal problem has always been the "80 character" part.

AFAIK it still warns for it. At least I see those warnings
regularly and I always ignore them for printk/pr_*

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
