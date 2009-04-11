Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbZDKR4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbZDKR4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 13:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbZDKR42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 13:56:28 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40215 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757328AbZDKR41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 13:56:27 -0400
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC
	attribute  structure in sysfs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pjones@redhat.com,
       konradr@linux.vnet.ibm.com, ketuzsezr@darnok.org,
       "Vishnu V. Mandyam" <vishnu@chelsio.com>
In-Reply-To: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 10:56:07 -0700
Message-Id: <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-11 at 18:59 +0530, Ashutosh Naik wrote:
> This patch fixes the display of a few fields in the iBFT NIC attribute
> structure in sysfs.
> 
> Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>
> Signed-off-by: Vishnu V<vishnu@chelsio.com>

What do these signoffs mean?  Traditionally you sign off on a patch if
it passed through your hands, so if this is a patch from Vishnu which
you're sending in, they need to be in reverse order (and a From: for
Vishnu).

The second question is who picks this up?  The drivers/firmware
directory doesn't seem to have a dedicated tree, so I can take this
through the SCSI tree if required or Andrew can take it through -mm.

James


