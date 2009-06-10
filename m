Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbZFJWdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbZFJWdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbZFJWdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:33:14 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:64333 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbZFJWdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:33:13 -0400
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 10
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20090610194309.4f7a0e54.sfr@canb.auug.org.au>
	<200906110027.38348.bzolnier@gmail.com>
Date: Wed, 10 Jun 2009 18:32:50 -0400
In-Reply-To: <200906110027.38348.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Thu, 11 Jun 2009 00:27:37 +0200")
Message-ID: <yq1bpov67ot.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A303495.01AE:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Bart" == Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

>     Revert "block: Fix bounce limit setting in DM"
>     This reverts commit a05c0205ba031c01bba33a21bf0a35920eb64833.
>     DM doesn't need to access the bounce_pfn directly.

Fix coming via the DM tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
