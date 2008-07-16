Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbYGPQVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbYGPQVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbYGPQUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:20:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:42365 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910AbYGPQUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:20:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,374,1212390000"; 
   d="scan'208";a="362108560"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Dropping WUSB/UWB from my patch queue
Date: Wed, 16 Jul 2008 09:20:30 -0700
Message-ID: <C72DEB015BA7724783363DE1AF6B0F9805393C24@orsmsx417.amr.corp.intel.com>
In-Reply-To: <487DC4FA.4050505@csr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Dropping WUSB/UWB from my patch queue
Thread-Index: AcjnKdutTmJVDBNgTiOg7v0gUr0RigANfBZA
References: <20080630180009.GA30833@kroah.com> <4871E9F0.60608@csr.com> <20080715155313.GA3075@kroah.com> <487CE2E7.90505@csr.com> <20080716054911.GA9806@kroah.com> <487DC4FA.4050505@csr.com>
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: "David Vrabel" <david.vrabel@csr.com>, "Greg KH" <greg@kroah.com>
Cc: "linux-usb" <linux-usb@vger.kernel.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Jul 2008 16:20:32.0625 (UTC) FILETIME=[DED1A610:01C8E75F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: David Vrabel [mailto:david.vrabel@csr.com]
>
>Postponed:
>
>* HWA radio controller driver
>* Wire Adapter core (for HWAs and DWAs).
>* HWA host controller
>* WLP support
>* i1480 firmware download driver.
>* i1480 WLP driver.

If I got you a fix for the USB reset stuff, would you be able to merge
these guys?

