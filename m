Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZIOOD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZIOOD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZIOODX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:03:23 -0400
Received: from mail09.linbit.com ([212.69.161.110]:57981 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbZIOODW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:03:22 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: drbd tree build failure
Date: Tue, 15 Sep 2009 16:03:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, drbd-dev@lists.linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nikanth Karthikesan <knikanth@suse.de>
References: <20090915160739.86e85ab3.sfr@canb.auug.org.au> <20090915062306.GP14984@kernel.dk> <20090915165309.f07381ec.sfr@canb.auug.org.au>
In-Reply-To: <20090915165309.f07381ec.sfr@canb.auug.org.au>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909151603.24843.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 September 2009 08:53:09 Stephen Rothwell wrote:
> Hi Jens,
>
> On Tue, 15 Sep 2009 08:23:06 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > Fix looks correct.
>
> Thanks for the confirmation.  So hopefully one of these trees will be
> merged by Linus soon an this can be fixed up in the other.

Thanks everybody.

I have applied Stephens' patch to the DRBD tree.

-phil

