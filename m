Return-Path: <linux-kernel-owner+w=401wt.eu-S1030777AbXDPPqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030777AbXDPPqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030779AbXDPPqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:46:53 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:25218 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030777AbXDPPqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:46:52 -0400
Date: Mon, 16 Apr 2007 17:46:50 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Christoph Hellwig <hch@infradead.org>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
In-Reply-To: <20070416145527.GA26863@infradead.org>
Message-ID: <Pine.BSO.4.63.0704161734370.11088@rudy.mif.pg.gda.pl>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> <17952.5537.364603.419364@notabene.brown>
 <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
 <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr>
 <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl> <46238204.9060907@s5r6.in-berlin.de>
 <Pine.BSO.4.63.0704161606280.11088@rudy.mif.pg.gda.pl> <20070416145527.GA26863@infradead.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1607077221-1176738410=:11088"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1607077221-1176738410=:11088
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 16 Apr 2007, Christoph Hellwig wrote:

> On Mon, Apr 16, 2007 at 04:20:41PM +0200, Tomasz K?oczko wrote:
>> ZFS on Solaris provides for many workloads better speed than any Linux
>> technology on the same hardware but ZFS ond FUSE in current form provides
>> lower speed than now avalaible Linux technologies.
>
> Numbers, please.  So far in all interesting benchmarks it actually
> was slower.  But when they're faster than XFS somewhere I'd defintly
> be interesting in looking at why this is true and if possible and
> important enough fix it.

Google still is working but .. (from my bookmarks):

http://cmynhier.blogspot.com/2006/05/zfs-io-reordering-benchmark.html
http://cmynhier.blogspot.com/2006/05/zfs-benchmarking.html

also some other interestig numbers can be founnd on:
http://milek.blogspot.com/2006/08/hw-raid-vs-zfs-software-raid-part-ii.html

Probably more can be find on looking for zfs+benchmark on 
http://blogs.sun.com/

IMO real power ZFS shows on growing number if phisical devices so don't 
look so close on this kind of documents because usualy it was prepared on 
limited number of devices.

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-1607077221-1176738410=:11088--
