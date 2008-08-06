Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbYHFRga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbYHFRga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbYHFRgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:36:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28529 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbYHFRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:36:17 -0400
To: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
	<yq1d4kmi5hl.fsf@sermon.lab.mkp.net>
	<Pine.LNX.4.64.0808061629220.10184@blonde.site>
	<1218040613.7493.13.camel@localhost.localdomain>
	<1218041582.7493.19.camel@localhost.localdomain>
	<Pine.LNX.4.64.0808061815360.27392@blonde.site>
Date: Wed, 06 Aug 2008 13:32:03 -0400
In-Reply-To: <Pine.LNX.4.64.0808061815360.27392@blonde.site> (Hugh Dickins's message of "Wed\, 6 Aug 2008 18\:21\:18 +0100 \(BST\)")
Message-ID: <yq17iauvylo.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Hugh" == Hugh Dickins <hugh@veritas.com> writes:

Hugh> Almost: I had to #include <scsi/scsi.h> to get SCSI_2 for the
Hugh> build somewhere (and a SCSI_2 seems to be worth 1 more than
Hugh> anyone else's 2), then it worked just fine for me thanks.

The DIF drives in question claim rev. 3 and are configured correctly
with James' patch in place.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
