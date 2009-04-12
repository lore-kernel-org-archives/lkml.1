Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZDLNIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZDLNIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZDLNIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:08:36 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:46510 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDLNIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:08:35 -0400
From: Konrad Rzeszutek <ketuzsezr@darnok.org>
Reply-To: ketuzsezr@darnok.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC attribute  structure in sysfs
Date: Sun, 12 Apr 2009 09:06:59 -0400
User-Agent: KMail/1.9.10
Cc: Ashutosh Naik <ashutosh.naik@gmail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       pjones@redhat.com, konradr@linux.vnet.ibm.com,
       "Vishnu V. Mandyam" <vishnu@chelsio.com>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com> <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
In-Reply-To: <1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904120907.08828.ketuzsezr@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The second question is who picks this up?  The drivers/firmware
> directory doesn't seem to have a dedicated tree, so I can take this
> through the SCSI tree if required or Andrew can take it through -mm.

Which way works best for everybody? I was thinking SCSI, since the end result 
of this module is to configure the storage used to bootstrap the box.
