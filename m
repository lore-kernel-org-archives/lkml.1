Return-Path: <linux-kernel-owner+w=401wt.eu-S1761038AbXJYOj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761038AbXJYOj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbXJYOjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:39:48 -0400
Received: from ts.adaptec.com ([162.62.93.58]:58644 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbXJYOjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:39:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/4] [SCSI] ips: handle scsi_add_host() failure, and other err cleanups
Date: Thu, 25 Oct 2007 10:39:45 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DD0A@otce2k301.adaptec.com>
In-Reply-To: <20071024234832.58C3B1F81AB@havoc.gtf.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/4] [SCSI] ips: handle scsi_add_host() failure, and other err cleanups
Thread-Index: AcgWmTZ5Sz6b7e8oTp2DPCx1Sb+1PQAe4M5g
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234832.58C3B1F81AB@havoc.gtf.org>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Jeff Garzik" <jeff@garzik.org>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>
Cc: <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK. Inspected. cleanup with zero risk.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeff Garzik
> Sent: Wednesday, October 24, 2007 7:49 PM
> To: LKML; linux-scsi@vger.kernel.org
> Cc: akpm@linux-foundation.org
> Subject: [PATCH 4/4] [SCSI] ips: handle scsi_add_host() 
> failure, and other err cleanups
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/scsi/ips.c |   18 +++++++++++++-----
>  1 files changed, 13 insertions(+), 5 deletions(-)
