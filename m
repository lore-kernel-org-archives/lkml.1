Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbXJYOdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbXJYOdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbXJYOd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:33:27 -0400
Received: from ts.adaptec.com ([162.62.93.58]:58478 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013AbXJYOd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:33:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/4] [SCSI] ips: trim trailing whitespace
Date: Thu, 25 Oct 2007 10:33:24 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DD04@otce2k301.adaptec.com>
In-Reply-To: <20071024234829.133121F81A7@havoc.gtf.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/4] [SCSI] ips: trim trailing whitespace
Thread-Index: AcgWmTVPOFFDLkW5Qoqoz+nZcsuOywAerB6A
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234829.133121F81A7@havoc.gtf.org>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Jeff Garzik" <jeff@garzik.org>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>
Cc: <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK. Inspected; trivial, clean and no sign of any code changes.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeff Garzik
> Sent: Wednesday, October 24, 2007 7:48 PM
> To: LKML; linux-scsi@vger.kernel.org
> Cc: akpm@linux-foundation.org
> Subject: [PATCH 2/4] [SCSI] ips: trim trailing whitespace
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/scsi/ips.c |   44 
> ++++++++++++++++++++++----------------------
>  drivers/scsi/ips.h |   12 ++++++------
>  2 files changed, 28 insertions(+), 28 deletions(-)
