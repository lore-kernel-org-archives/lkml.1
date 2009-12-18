Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbZLRWdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbZLRWdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933101AbZLRWdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:33:43 -0500
Received: from khc.piap.pl ([195.187.100.11]:43247 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbZLRWdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:33:42 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
	<200912171708.07899.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
	<Pine.LNX.4.64.0912181118390.23738@hs20-bc2-1.build.redhat.com>
Date: Fri, 18 Dec 2009 23:33:39 +0100
In-Reply-To: <Pine.LNX.4.64.0912181118390.23738@hs20-bc2-1.build.redhat.com>
	(Mikulas Patocka's message of "Fri, 18 Dec 2009 11:32:00 -0500 (EST)")
Message-ID: <m3skb7zzcs.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> It would be best to keep line length is unlimited and say that it is the 
> responsibility of the viewer to wrap it.

It would mean no continuation lines due to length at all.
Perhaps it's the way to go.
-- 
Krzysztof Halasa
