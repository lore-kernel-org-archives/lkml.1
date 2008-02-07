Return-Path: <linux-kernel-owner+w=401wt.eu-S935248AbYBGVfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935248AbYBGVfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762854AbYBGVfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:35:18 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:41657 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762782AbYBGVfQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:35:16 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Xilinx: hwicap driver comments
Date: Thu, 7 Feb 2008 13:35:09 -0800
In-Reply-To: <fa686aa40802071331l16b40bacm4a7ca01a7219f1fb@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Xilinx: hwicap driver comments
Thread-Index: Achp0Mkzxomx4DDlQbCTY+aSXhjRRgAAEirg
References: <47AB6552.7040503@gmail.com> <20080207124203.147ce300.akpm@linux-foundation.org> <fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com> <20080207132106.ec5ebf1d.akpm@linux-foundation.org> <fa686aa40802071331l16b40bacm4a7ca01a7219f1fb@mail.gmail.com>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "Grant Likely" <grant.likely@secretlab.ca>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <jirislaby@gmail.com>, <linux-kernel@vger.kernel.org>, <paulus@samba.org>,
       <galak@gate.crashing.org>, <benh@kernel.crashing.org>,
       <torvalds@linux-foundation.org>
X-OriginalArrivalTime: 07 Feb 2008 21:35:10.0697 (UTC) FILETIME=[50EED590:01C869D1]
Message-Id: <20080207213512.36FA991807D@mail185-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It seems wrong that the signoff trail for that patch didn't actually
> > reflect reality - it should have had both Josh's and Paul's
signoffs.  That
> > would require that the changelog be altered during git->git
transfers which
> > I expect is just incompatible with the way git works (as far as I
dimly
> > understand it).

I'm rather new to all this and still (to some extent) trying to figure
out what is expected.

Maybe what is needed is git pull --ack?

Steve

