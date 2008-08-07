Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYHGS0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYHGS0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYHGS02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:26:28 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:35060 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYHGS01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:26:27 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>
Date: Thu, 7 Aug 2008 18:25:51 +0000
Subject: RE: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Thread-Topic: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Thread-Index: Acj4tX0gw3zrpINbQ5eYLdmHhe8lGAABSPlA
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3F6BEF4@GVW0547EXC.americas.hpqcorp.net>
References: <20080730211842.GF1758@roadking.ldev.net>
 <20080804095633.GA20055@kernel.dk>
 <20080805153012.0076396e.akpm@linux-foundation.org>
 <20080806130825.1567d882.sfr@canb.auug.org.au>
 <20080806103308.GM20055@kernel.dk>
 <20080807094305.8d315d06.sfr@canb.auug.org.au>
 <0F5B06BAB751E047AB5C87D1F77A778826B3F16682@GVW0547EXC.americas.hpqcorp.net>
 <20080807172028.GX20055@kernel.dk>
In-Reply-To: <20080807172028.GX20055@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens wrote:

> > > > uptodate more frequently :-)
> > >
> >
> > I still can't find my latest patches in any tree. Jens?
>
> It's in for-next, for-akpm, and for-linus. It'll be going
> upstream for this release, 2.6.27.

Thanks, I'm just a bit impatient I guess. When a patch makes into for-* how long would it take to get to Linus' git tree?

-- mikem
