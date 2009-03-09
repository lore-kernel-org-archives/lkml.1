Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZCIUXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZCIUXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZCIUXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:23:10 -0400
Received: from e3.win-professional.com ([85.214.150.225]:48190 "EHLO
	e3.win-professional.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZCIUXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:23:10 -0400
Subject: RE:  Re: [PATCH] xen: core dom0 support
Date: Mon, 9 Mar 2009 20:51:57 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F67@exchange01.corp.win-professional.com>
Content-class: urn:content-classes:message
In-Reply-To: A<loom.20090308T141818-855@post.gmane.org>
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [PATCH] xen: core dom0 support
Thread-Index: Acmf+oWG5q+U9gmSTs6ghpsSeUFl+QA9ReGw
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <B4ED8DE8E195E84A872496A085BC07822F42@exchange01.corp.win-professional.com> A<loom.20090308T141818-855@post.gmane.org>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "Manfred Knick" <Manfred.Knick@T-Online.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Mar 2009 19:51:58.0192 (UTC) FILETIME=[817E8F00:01C9A0F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Do you perhaps have the corresponding figures regarding e.g. VMware
ESX(i)
> available?

Yes.

HDD: XEN | KVM | ESXi

Write: 110 MB/s | 60 MB/s | 35 MB/s
Read: 130 MB/s  | 80 MB/s | 160 MB/s

Network Performance: (download an 4 GB iso image from apache webserver)

XEN | KVM | ESXi

download Speed: 105 MB/s | 50 MB/s | 43 MB/s

Overall, xen is the most powerful virtualization platform on our IBM
servers.


Best regards,

Morten

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Manfred Knick
Sent: Sunday, March 08, 2009 3:25 PM
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: core dom0 support

Morten P.D. Stevens <mstevens <at> win-professional.com> writes:

> Here some benchmarks with Citrix XenServer 5.0 vs KVM with linux and
windows
guests on an IBM x3400 server:

Thanks!
Just out of curiosity, to complete your appreciated impression:
Do you perhaps have the corresponding figures regarding e.g. VMware
ESX(i)
available?

Thanks in advance!
Manfred


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
