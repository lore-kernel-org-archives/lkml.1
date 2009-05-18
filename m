Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZERJy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZERJy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZERJsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:48:46 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:15955 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756002AbZERJsm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:48:42 -0400
X-BigFish: VPS-20(zz1432R98dR1805M873fnzz1202hzz2ba5Mz32i6bh6di43j)
X-FB-SS: 5,13,
X-WSS-ID: 0KJU38X-01-M8D-01
Date: Mon, 18 May 2009 11:48:22 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: linux-next: Tree for May 15
Message-ID: <20090518094822.GB4905@aftab>
References: <20090515153733.4384db9f.sfr@canb.auug.org.au> <20090515130729.GA13026@aftab> <20090518000734.6fd3d652.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090518000734.6fd3d652.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 18 May 2009 09:48:23.0161 (UTC) FILETIME=[C891DE90:01C9D79D]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, May 18, 2009 at 12:07:34AM +1000, Stephen Rothwell wrote:
> Hi Boris,
> 
> On Fri, 15 May 2009 15:07:29 +0200 Borislav Petkov <borislav.petkov@amd.com> wrote:
> >
> > can you please add the tree at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next
> > 
> > to linux-test for a wider testing. It is rebased ontop of
> > 45d447406a19cbfd42720f066f156f4eb9d68801 (Linus's tree from yesterday).
> 
> A hint as to what the tree is about would be nice.  It looks like EDAC
> stuff (mostly AMD64).

It is an EDAC module for AMD k8, Fam10h and Fam11h processors.

> If so, you are not listed as a maintainer of that code (Doug cc'd).

I'll send a patch to update that later.

> The boilerplate:
> 
> What I tell everyone: all patches/commits in the tree/series must
> have been:
> 
> 	posted to a relevant mailing list

done, lkml.

> 	reviewed

The review process had 3 iterations, see:

http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02606.html
http://lwn.net/Articles/332324/
http://lkml.indiana.edu/hypermail/linux/kernel/0905.1/03571.html

Reviewers: x86 maintainers, Andrew Morton, Greg KH, Mauro Carvalho Chehab

> 	unit tested

done.

> 	destined for the next merge window (or the current release)

It is destined for the .31 merge window, as Andrew suggested.

Let me know if there's anything more needed.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

