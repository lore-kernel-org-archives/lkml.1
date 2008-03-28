Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYC1CKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYC1CKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbYC1CKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:10:37 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:38791 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbYC1CKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:10:36 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] fsldma: The MPC8377MDS board device tree node for fsldma driver
Date: Fri, 28 Mar 2008 10:10:23 +0800
Message-ID: <78567AC4946EDC42B7DE978C350CD869EC5A06@zch01exm26.fsl.freescale.net>
In-Reply-To: <e9c3a7c20803271237x1b2c3a2ci6837c5e2d5288c95@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsldma: The MPC8377MDS board device tree node for fsldma driver
Thread-Index: AciQQhV5QkZ6+n2JQ5CJKr3K1jm1QQANnXKg
References: <1206517356-11209-1-git-send-email-wei.zhang@freescale.com> <1206517356-11209-2-git-send-email-wei.zhang@freescale.com> <e9c3a7c20803271237x1b2c3a2ci6837c5e2d5288c95@mail.gmail.com>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Dan Williams" <dan.j.williams@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Kumar Gala" <galak@kernel.crashing.org>, <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan,

Sure. The patch can be just a reference to how to config and enable the fsldma driver in dts file on MPC83xx boards.

Thanks!
Wei.

> -----Original Message-----
> From: dan.j.williams@gmail.com 
> [mailto:dan.j.williams@gmail.com] On Behalf Of Dan Williams
> Sent: Friday, March 28, 2008 3:38 AM
> To: Zhang Wei; Andrew Morton
> Cc: Linux Kernel; Kumar Gala; linuxppc-dev@ozlabs.org
> Subject: Re: [PATCH] fsldma: The MPC8377MDS board device tree 
> node for fsldma driver
> 
> On Wed, Mar 26, 2008 at 12:42 AM, Zhang Wei 
> <wei.zhang@freescale.com> wrote:
> > The fsldma driver is tested on MPC8377MDS board.
> >  The patch adds fsldma driver support into MPC8377MDS device tree.
> >
> >  Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> >  ---
> >   arch/powerpc/boot/dts/mpc8377_mds.dts |   27 
> +++++++++++++++++++++++++++
> >   1 files changed, 27 insertions(+), 0 deletions(-)
> 
> I think this patch should probably go through the powerpc tree, or
> -mm.  I'll pick up the ones that touch either drivers/dma or
> crypto/async_tx.
> 
> --
> Dan
> 
