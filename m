Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbZBFWM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbZBFWM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZBFWMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:12:51 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:57420 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZBFWMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:12:50 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: AW:  Re: linux 2.6.29-rc3 kernel failure with mptsas
Content-class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 6 Feb 2009 23:12:46 +0100
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F13@exchange01.corp.win-professional.com>
In-Reply-To: <gmhsk4$4ht$2@ger.gmane.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: linux 2.6.29-rc3 kernel failure with mptsas
Thread-Index: AcmIggqG3poM/JQ1RKeimaJMua330QAJP9pQ
References: <B4ED8DE8E195E84A872496A085BC07822F11@exchange01.corp.win-professional.com> <gmhsk4$4ht$2@ger.gmane.org>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Feb 2009 22:12:47.0672 (UTC) FILETIME=[0AF8A380:01C988A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> See what it does without the tainted kernel?

Same problem without a tainted kernel. (2.6.29-rc3)

-----Ursprüngliche Nachricht-----
Von: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] Im Auftrag von Bill Davidsen
Gesendet: Freitag, 6. Februar 2009 18:39
An: linux-kernel@vger.kernel.org
Betreff: Re: linux 2.6.29-rc3 kernel failure with mptsas

Morten P.D. Stevens wrote:
> Hi,
> 
> I get a kernel failure with linux 2.6.29-rc3 on my Dell T7400
> Workstation.
> 
> failure message:
> 
> WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a8/0x353()
> (Tainted: G        W )
> Hardware name: Precision WorkStation T7400  
> Modules linked in: ata_generic pata_acpi mptsas(+) mptscsih mptbase
> scsi_transport_sas
> Pid: 35, comm: work_on_cpu/0 Tainted: G        W
> 2.6.29-0.66.rc3.fc11.x86_64 #1

> 
> Any ideas about the problem?
> 
See what it does without the tainted kernel?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
