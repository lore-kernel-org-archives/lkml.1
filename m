Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbXLJRz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbXLJRz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 12:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXLJRzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 12:55:49 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:23066 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751705AbXLJRzr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 12:55:47 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22.14 oops msg with commvault galaxy ?
Date: Mon, 10 Dec 2007 12:55:24 -0500
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0015201C3@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <20071210091501.deed38fa.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22.14 oops msg with commvault galaxy ?
Thread-Index: Acg7UFGxPEE2ecSwTbKBC6hIInUm6gAAbYfA
References: <20071207151113.e9841341.akpm@linux-foundation.org><20071207171455.b2eecb60.randy.dunlap@oracle.com><F1D642E5A91BC94D9504EC83AE19E6B0015201AF@ecqcmtlmail3.quebec.int.ec.gc.ca><F1D642E5A91BC94D9504EC83AE19E6B0015201B1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071210091501.deed38fa.randy.dunlap@oracle.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>
X-OriginalArrivalTime: 10 Dec 2007 17:55:24.0599 (UTC) FILETIME=[D708B470:01C83B55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : Randy Dunlap [mailto:randy.dunlap@oracle.com] 
> Envoyé : 10 décembre 2007 12:15
> 
> On Mon, 10 Dec 2007 09:03:17 -0500 Fortier,Vincent [Montreal] wrote:
> 
> Ingo, can you look at this, please?
> Vincent is getting oopses on 2.6.22.14-cfs-etch.
> 
> Vincent, did you apply the cfs patch or did Debian etch provide that?

I did. http://linux-dev.qc.ec.gc.ca/

> If you applied it, did you use
> http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.6.22.13-v24.patch
> or a different patch?
> 

I applied exactly that one.. and had already sent that info to ingo this morning since I presumed the CFS patchset could be involved in this by reagarding the more detailed output.

Also note that CFS v24 on 2.6.21 does not produce the oops and I can run galaxy backups on the system without any problems.

- vin
