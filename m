Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYCKIxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYCKIxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 04:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYCKIxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 04:53:38 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:49613 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYCKIxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 04:53:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 11/17] Add memory mapping driver to RapidIO.
Date: Tue, 11 Mar 2008 16:53:09 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AECE5158@zch01exm26.fsl.freescale.net>
In-Reply-To: <20080305135148.21d6c25a.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 11/17] Add memory mapping driver to RapidIO.
Thread-Index: Ach+a+STw/XzO6ZeRQim2p8xFWP/HAE6Uwzg
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com><1204648202-5495-2-git-send-email-wei.zhang@freescale.com><1204648202-5495-3-git-send-email-wei.zhang@freescale.com><1204648202-5495-4-git-send-email-wei.zhang@freescale.com><1204648202-5495-5-git-send-email-wei.zhang@freescale.com><1204648202-5495-6-git-send-email-wei.zhang@freescale.com><1204648202-5495-7-git-send-email-wei.zhang@freescale.com><1204648202-5495-8-git-send-email-wei.zhang@freescale.com><1204648202-5495-9-git-send-email-wei.zhang@freescale.com><1204648202-5495-10-git-send-email-wei.zhang@freescale.com><1204648202-5495-11-git-send-email-wei.zhang@freescale.com><20080304213735.c77d6203.sfr@canb.auug.org.au><ABF87B0B6A38C0458E319AC973ED68AECE4522@zch01exm26.fsl.freescale.net> <20080305135148.21d6c25a.sfr@canb.auug.org.au>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen,

I've updated those patches with fixing up.

Thanks! 
Wei.

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
> Sent: Wednesday, March 05, 2008 10:52 AM
> To: Zhang Wei
> Cc: linuxppc-dev@ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 11/17] Add memory mapping driver to RapidIO.
> 
> Hi Weu,
> 
> On Wed, 5 Mar 2008 09:59:38 +0800 "Zhang Wei" 
> <Wei.Zhang@freescale.com> wrote:
> >
> > Thanks! I'm considering to commit a updated patch or new 
> code cleaning
> > patch.
> > How about your idea?
> 
> Preferably, fix up the patches.  If that is a pain, then a 
> followup patch
> that cleans up is ok as these do not affect the correctness 
> of the code.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> 
