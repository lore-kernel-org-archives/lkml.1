Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbXGSUFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbXGSUFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759189AbXGSUFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:05:17 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:45911 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760345AbXGSUFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:05:15 -0400
Date: Thu, 19 Jul 2007 21:05:12 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Satyam Sharma <satyam.sharma@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Avi Kivity <avi@qumranet.com>,
       =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<ukleinek@informatik.uni-freiburg.de>,
       Jens Axboe <axboe@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       dri-devel@lists.sourceforge.net,
       =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@tungstengraphics.com>,
       =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>,
       Charles Gagalac <charles.gagalac@gmail.com>
Subject: Re: [1/2] 2.6.22-git: known regressions
In-Reply-To: <469F92A1.5070203@googlemail.com>
Message-ID: <Pine.LNX.4.64.0707192104210.3788@skynet.skynet.ie>
References: <469F92A1.5070203@googlemail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1103454139-1184875512=:3788"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1103454139-1184875512=:3788
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

>
> DRM
>
> Subject         : wine locks up system
> References      : http://lkml.org/lkml/2007/7/17/128
> Last known good : ?
> Submitter       : Charles Gagalac <charles.gagalac@gmail.com>
> Caused-By       : commit d4e2cbe9cb9219fc924191a6baa2369140cb5ea8
>                  Dave Airlie <airlied@linux.ie>
>                  Michel Dänzer <michel@tungstengraphics.com>
>                  Kristian Høgsberg <krh@redhat.com>
> Handled-By      :
> Status          : unknown

Fixed about an hour later...45ea5dcde62db8eccc8503defae3c3353256975d

Dave.

>
>
>
> Regards,
> Michal
>
> --
> LOG
> http://www.stardust.webpages.pl/log/
>

-- 
David Airlie, Software Engineer
http://www.skynet.ie/~airlied / airlied at skynet.ie
Linux kernel - DRI, VAX / pam_smb / ILUG

--29444707-1103454139-1184875512=:3788--
