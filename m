Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbXJQUBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbXJQUBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbXJQUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:01:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28288 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535AbXJQUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:01:44 -0400
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [git patch] libata build fix
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20071015221329.GA8778@havoc.gtf.org>
	<200710170123.43244.bzolnier@gmail.com>
Date: Wed, 17 Oct 2007 16:00:27 -0400
In-Reply-To: <200710170123.43244.bzolnier@gmail.com> (Bartlomiej Zolnierkiewicz's message of "Wed\, 17 Oct 2007 01\:23\:43 +0200")
Message-ID: <yq18x618qas.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "BZ" == Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

BZ> We probably need also this one for pata_cs5536:

BZ> [PATCH] pata_cs5536: MWDMA fix

BZ> * Fix out-of-bound array access for MWDMA modes.

BZ> * Bump driver version.

Obviously correct.  

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

