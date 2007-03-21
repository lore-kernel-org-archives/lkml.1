Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXCUSjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXCUSjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXCUSjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:39:53 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27536 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933414AbXCUSjw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:39:52 -0400
X-BigFish: VP
X-FB-SS: 0
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH]: Resubmitting: __init to __cpuinit in mtrr code
Date: Wed, 21 Mar 2007 13:39:35 -0500
Message-ID: <ED126CFB3EBB3B43A3A6D59E518424A7C0D856@SAUSEXMB3.amd.com>
In-Reply-To: <46014F8B.1070104@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]: Resubmitting: __init to __cpuinit in mtrr code
Thread-Index: Acdr0C6RHAWQsCD2RFG776vDp9L07wAF7bcw
From: "Nagendra, Bhavana" <bhavana.nagendra@amd.com>
To: "Prarit Bhargava" <prarit@redhat.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 21 Mar 2007 18:39:36.0666 (UTC)
 FILETIME=[46BC03A0:01C76BE8]
X-WSS-ID: 6A1FA4632EW1725381-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Prarit Bhargava wrote:
> Originally submitted 2007-02-28.  Adding Bhavana from AMD...
>
> __init to __cpuinit in mtrr code.
>
> Resolves warnings similar to:
>
> WARNING: vmlinux - Section mismatch: reference to
.init.text:mtrr_bp_init from .text between 'identify_cpu' (at offset
0xc040b38e) and 'detect_ht'
>

Acked-by: Bhavana Nagendra <Bhavana.nagendra@amd.com>

> 

Regards,
--
Bhavana Nagendra
AMD, Inc



