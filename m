Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbYFJTDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbYFJTDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYFJTDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:03:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYFJTDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:03:03 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3 of 7] block: Find bio sector offset given idx and offset
References: <318fa71e735d25003f9c.1212814536@sermon.lab.mkp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Jun 2008 15:02:51 -0400
In-Reply-To: <318fa71e735d25003f9c.1212814536@sermon.lab.mkp.net> (Martin
	K. Petersen's message of "Sat, 07 Jun 2008 00:55:36 -0400")
Message-ID: <x49ej759kpw.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> 2 files changed, 26 insertions(+)
> fs/bio.c            |   24 ++++++++++++++++++++++++
> include/linux/bio.h |    2 ++
>
>
> Helper function to find the sector offset in a bio given bvec index
> and page offset.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
