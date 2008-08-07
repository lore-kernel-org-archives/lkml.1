Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbYHGPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbYHGPbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYHGPbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:31:10 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:3380 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYHGPbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:31:09 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>
Date: Thu, 7 Aug 2008 15:29:44 +0000
Subject: RE: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Thread-Topic: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Thread-Index: Acj4HjQDJKhi0Ft8RTSKlnSb4nJjuwAhA9DA
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3F16682@GVW0547EXC.americas.hpqcorp.net>
References: <20080730211842.GF1758@roadking.ldev.net>
	<20080804095633.GA20055@kernel.dk>
	<20080805153012.0076396e.akpm@linux-foundation.org>
	<20080806130825.1567d882.sfr@canb.auug.org.au>
	<20080806103308.GM20055@kernel.dk>
 <20080807094305.8d315d06.sfr@canb.auug.org.au>
In-Reply-To: <20080807094305.8d315d06.sfr@canb.auug.org.au>
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



> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Wednesday, August 06, 2008 6:43 PM
> To: Jens Axboe
> Cc: Andrew Morton; Miller, Mike (OS Dev);
> linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support
> is disabled
>
> Hi Jens,
>
> On Wed, 6 Aug 2008 12:33:08 +0200 Jens Axboe
> <jens.axboe@oracle.com> wrote:
> >
> > Thanks, but just keep pulling linux-next and I'll try and get them
> > uptodate more frequently :-)
>

I still can't find my latest patches in any tree. Jens?

-- mikem
