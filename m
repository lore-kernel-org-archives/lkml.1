Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZAFIkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZAFIkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 03:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZAFIk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 03:40:29 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60518 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZAFIk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 03:40:28 -0500
Date: Tue, 06 Jan 2009 01:40:10 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 7/9] exofs: mkexofs
In-reply-to: <1230739053.3408.74.camel@localhost.localdomain>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>, avishay@gmail.com,
       jeff@garzik.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       osd-dev@open-osd.org, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Message-id: <20090106084010.GI3932@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com>
 <20081229121423.efde9d06.akpm@linux-foundation.org>
 <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 31, 2008  15:57 +0000, James Bottomley wrote:
> I don't like it mainly because it's not truly a useful general framework
> for others to build on.  However, as argued above, there might not
> actually be such a useful framework, so as long as the only two
> consumers (you and Lustre) want an interface like this, I'll put it in.

To be clear - Lustre has nothing to do with T10-OSD interfaces.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

