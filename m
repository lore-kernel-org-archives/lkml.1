Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbXF1LN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbXF1LN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXF1LNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:13:17 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:58721 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbXF1LNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:13:16 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] PXA27x UDC driver.
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 28 Jun 2007 19:15:06 +0800
Message-ID: <989B956029373F45A0B8AF0297081890D834FA@zch01exm26.fsl.freescale.net>
In-Reply-To: <20070628103619.GW13886@enneenne.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] PXA27x UDC driver.
Thread-Index: Ace5cHGebTyNz9UkT/mXWzRD59CirwABFiIQ
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: "Rodolfo Giometti" <giometti@enneenne.com>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Rodolfo
Giometti
> Sent: Thursday, June 28, 2007 6:36 PM
> To: linux-arm-kernel@lists.arm.linux.org.uk
> Cc: linux-kernel@vger.kernel.org; Andrew Morton
> Subject: [PATCH] PXA27x UDC driver.
> 
> Hello,
> 
> attached you can find new version of my patch for PXA27x UDC driver
> support against kernel 2.6.22-rc3 (but it applies also ro rc6).
> 
> I'd like to know what I have to do in order to prepare this patch for
> kernel inclusion. It's time PXA27x has its UDC driver into linux! :)
> 
> Thanks for your suggestions,

You should probably also cc: linux-usb-devel@lists.sourceforge.net and
David Brownell for UDC matters.

- Leo
