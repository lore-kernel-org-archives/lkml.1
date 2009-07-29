Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbZG2PLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbZG2PLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZG2PLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:11:25 -0400
Received: from mail09.linbit.com ([212.69.161.110]:50533 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZG2PLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:11:24 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: drbd tree build failure
Date: Wed, 29 Jul 2009 17:11:22 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Lars Ellenberg <lars.ellenberg@linbit.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090727154816.24e81531.sfr@canb.auug.org.au> <20090728142040.9b2df926.sfr@canb.auug.org.au> <200907291110.56241.rusty@rustcorp.com.au>
In-Reply-To: <200907291110.56241.rusty@rustcorp.com.au>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907291711.22466.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009 03:40:55 Rusty Russell wrote:
> On Tue, 28 Jul 2009 01:50:40 pm Stephen Rothwell wrote:
> > Hi Philipp, Lars,
> >
> > On Mon, 27 Jul 2009 19:17:55 +0200 Philipp Reisner 
<philipp.reisner@linbit.com> wrote:
> > > Ok. Lars' patch is now complete and arrived in the git tree...
> > >
> > > It should build now with Rusty's paches.
> >
> > Thanks.
>
> This is untested, but fairly trivial transform to avoid cpumask_t in the
> struct as well:
>

Thanks,

I have commited that patch to the DRBD git tree.

-phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

