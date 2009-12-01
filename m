Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZLARQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZLARQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZLARQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:16:43 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:51045 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZLARQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:16:42 -0500
To: James Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.32-rc8
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1259620194.11762.137.camel@mulgrave.site>
	<20091201080346W.fujita.tomonori@lab.ntt.co.jp>
	<1259676366.11762.239.camel@mulgrave.site>
Date: Tue, 01 Dec 2009 12:15:24 -0500
In-Reply-To: <1259676366.11762.239.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 01 Dec 2009 09:06:06 -0500")
Message-ID: <yq1vdgqzkcz.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B154F41.014A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If we are doing another small batch of SCSI fixes before .32 I'd like to
see Mike Christie's error handling fix go in as well.  I just noticed it
ended up being queued in scsi-misc and not scsi-rc-fixes.  It really is
an important bug fix. ad63082626f99651d261ccd8698ce4e997362f7e

-- 
Martin K. Petersen	Oracle Linux Engineering
