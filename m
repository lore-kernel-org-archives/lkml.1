Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbZHTW1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbZHTW1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 18:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZHTW1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 18:27:21 -0400
Received: from hq-exedge.brocade.com ([66.243.153.82]:34800 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZHTW1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 18:27:20 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 18:27:20 EDT
From: Jing Huang <huangj@Brocade.COM>
To: Jing Huang <huangj@Brocade.COM>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>,
       Ashok Rajagopalan <arajagop@Brocade.COM>
Date: Thu, 20 Aug 2009 15:22:16 -0700
Subject: Request to include  Brocade BFA FC SCSI driver into Linux SCSI tree
Thread-Topic: Request to include  Brocade BFA FC SCSI driver into Linux SCSI
 tree
Thread-Index: AcohY0dqSPoVAGHqQC2IPqSf6KmXqwAf/ZAQ
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECB1A935D74@HQ-EXCH-7.corp.brocade.com>
References: <200908200654.n7K6shpn005971@swe57.brocade.com>
In-Reply-To: <200908200654.n7K6shpn005971@swe57.brocade.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

I resubmitted the bfa driver patches which include fixes for some code review comments provided by Sam Ravnborg on our July 20 submission.

Here, on behalf of Brocade Communication System, Inc, I am requesting you to include the driver into the linux SCSI tree. We will continue to enhance the driver and fix issues reported from linux-scsi community and our internal test group as well.

Thanks and best regards.

Jing Huang
Brocade Communications Systems

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Jing Huang
> Sent: Wednesday, August 19, 2009 11:55 PM
> To: James.Bottomley@HansenPartnership.com
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Ramkumar
> Vadivelu; Vinodh Ravindran
> Subject: [PATCH 0/14] bfa: Brocade BFA FC SCSI driver (overview)
> 
> From: Jing Huang <huangj@brocade.com>
> 
> Resubmitting the patches after implemented some of the code review
> comments
> from Sam Ravnborg. Patches are generated using 2.6.31-rc6 kernel.
> 
> [PATCH 1/14]: SCSI LLD driver code, module init/exit, PCI and SCSI host
> entry
> points, interrupt handler, and sysfs interface etc.
> 
> [PATCH 2/14]: Hardware/FW access code. part-1
> 
> [PATCH 3/14]: Hardware/FW access code. part-2
> 
> [PATCH 4/14]: Hardware/FW access code. part-3
> 
> [PATCH 5/14]: Hardware/FW access code. part-4
> 
> [PATCH 6/14]: FC state machines. part-1
> 
> [PATCH 7/14]: FC state machines. part-2
> 
> [PATCH 8/14]: FC state machines. part-3
> 
> [PATCH 9/14]: FC state machines. part-3
> 
> [PATCH 10/14]: Common header files shared by linux driver,
> hardware/FW access code, FC state machines. part-1
> 
> [PATCH 11/14]: Common header files shared by linux driver,
> hardware/FW access code, FC state machines. part-2
> 
> [PATCH 12/14]: Common header files shared by linux driver,
> hardware/FW access code, FC state machines. part-3
> 
> [PATCH 13/14]: Updated Kconfig and Makefile for driver/scsi, and Makefile
> for bfa driver
> 
> [PATCH 14/14]: Updated MAINTAINER file.
> 
> Signed-off-by: Jing Huang <huangj@brocade.com>
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
