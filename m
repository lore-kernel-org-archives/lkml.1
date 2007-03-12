Return-Path: <linux-kernel-owner+w=401wt.eu-S965519AbXCLKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbXCLKkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965521AbXCLKkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:40:51 -0400
Received: from tag.witbe.net ([81.88.96.48]:55557 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965519AbXCLKku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:40:50 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Vincent Fortier'" <vincent.fortier1@ec.gc.ca>,
       "'LKML'" <linux-kernel@vger.kernel.org>
Subject: RE: RSDL v0.30 cpu scheduler for ... 2.6.18.8 kernel
Date: Mon, 12 Mar 2007 11:40:44 +0100
Organization: AS2917.net
Message-ID: <009601c76492$e6844760$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <200703120417.57761.vincent.fortier1@ec.gc.ca>
Thread-Index: AcdkVRFiDN33f5SyQkCTulKPF2UWVQAPZepQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vincent,

> patched kernel.  Now it looks more like 5 seconds faster!  
> Wow.. nice work CK!
> 
> 2.6.18.8 vanilla kernel:
> [   48.185716] libata version 2.00 loaded.
> [   49.838513] scsi0 : sata_nv
> 
> 
> 2.6.18.8-rsdl-0.30:
> [   43.144312] libata version 2.00 loaded.
> [   45.820504]   Vendor: ATA       Model: Maxtor 6B250S0    Rev: BANC
> [   45.822721]   Type:   Direct-Access                      

As it seems the 5s net gain is during the early phase of the boot process,
could you please post longer dmesgs, to let us know where the gain occurs ?

Regards,
Paul

