Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbYE1TGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbYE1TGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYE1TFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:05:47 -0400
Received: from lucidpixels.com ([75.144.35.66]:51660 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbYE1TFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:05:46 -0400
Date: Wed, 28 May 2008 15:05:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
In-Reply-To: <20080528190242.GA5171@rap.rap.dk>
Message-ID: <alpine.DEB.1.10.0805281504160.29755@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <20080528190242.GA5171@rap.rap.dk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-443333512-1212001546=:29755"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-443333512-1212001546=:29755
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 28 May 2008, Keld J=F8rn Simonsen wrote:

> I added this in the wiki performance section.
Ok.

> I think it would have been informative if also a test with one drive in
> a non-raid setup was described.
Since the performance of bonnie++ deals with single threads/a raid1 would p=
robably closely match it but yeah I could do that sometime.

>
> Are there any particular findings you want to highlight?
Not in particular, just I could never find this information provided anywhe=
re
that showed all of the raid variation/types in one location that was easy t=
o
read.

>
> Is there some way to estimate random read and writes from this test?
The sequential input and output and re-write speeds are the most important.

>
> Are the XFS file systems completely new when running the tests?
Yes, after the creation of each array, mkfs.xfs -f /dev/md3 was run to ensu=
re
a clean mount and cron was also off throughout all testing.

>
> Best regards
> keld
---1463747160-443333512-1212001546=:29755--
