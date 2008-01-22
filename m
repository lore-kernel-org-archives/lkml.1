Return-Path: <linux-kernel-owner+w=401wt.eu-S1759843AbYAVIZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbYAVIZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 03:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbYAVIZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 03:25:18 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:64670 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbYAVIZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 03:25:06 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH v2] Add DMA engine driver for Freescale MPC85xx processors.
Date: Tue, 22 Jan 2008 16:25:00 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AEB82A57@zch01exm26.fsl.freescale.net>
In-Reply-To: <e9c3a7c20801101021n7aa37bdrd6255245a773546e@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] Add DMA engine driver for Freescale MPC85xx processors.
Thread-Index: AchTta2q1GBE2hR5TKSTQmpJYox5QwJGdSXQ
References: <e9c3a7c20801101021n7aa37bdrd6255245a773546e@mail.gmail.com>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, "Zhu Ebony" <ebony.zhu@freescale.com>,
       <galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan, 

> -----Original Message-----
> From: dan.j.williams@gmail.com 
>
> I do not think all the review comments have been addressed, for
> example my earlier comments about GFP_ATOMIC and spin_lock_irqsave
> [1].  We have two options to take this forward:
> 

Thanks! Some comments need more study, I'll discuss them with you later.

> 1/ Continue to carry this in the async-tx tree and get an
> Acked-by/Reviewed-by tag from Kumar.
> 2/ Move this to Kumar's tree, and coordinate our pull requests to have
> the async-tx updates hit first.
> 
> I prefer option 1, but I will defer to Kumar.
> 

I also prefer option 1. How about now?

Cheers!
Wei.
