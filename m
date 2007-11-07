Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbXKGIf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbXKGIf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 03:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbXKGIfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 03:35:50 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:29196 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbXKGIft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 03:35:49 -0500
In-Reply-To: <20071106223119.GC31367@localhost.localdomain>
References: <OF6FC435A0.F59C9AD9-ONC125738B.002A5195-C125738B.002A424A@de.ibm.com>	<200711061606.04402.hnguyen@linux.vnet.ibm.com> <20071106223119.GC31367@localhost.localdomain>
Subject: Re: [ofa-general] Re: problem in follow_hugetlb_page on ppc64	architecture
 with get_user_pages
To: David Gibson <dwg@au1.ibm.com>
Cc: general@lists.openfabrics.org, general-bounces@lists.openfabrics.org,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Roland Dreier <rdreier@cisco.com>
X-Mailer: Lotus Notes Release 8.0 August 02, 2007
Message-ID: <OF5896F13F.53CE0380-ONC125738C.002C57D6-C125738C.002CB369@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Wed, 7 Nov 2007 09:35:44 +0100
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 07/11/2007 09:35:45
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


general-bounces@lists.openfabrics.org wrote on 06.11.2007 23:31:19:


> We should cut this down to the bare necessary and fold it into the
> libhugetlbfs testsuite.

Well, this testcase is already pretty close to the bare minimum
what's needed to run IB/RDMA queues.
You can compare this to for example ibv_rc_pingpong in libibverbs...

Maybe it's possible to test this with anything else than IB?

> --
Gruss / Regards
Christoph R

