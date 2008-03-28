Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYC1C0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYC1C0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbYC1C0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:26:06 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:35101 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbYC1C0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:26:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] fsldma: The MPC8377MDS board device tree node for fsldma driver
Date: Fri, 28 Mar 2008 10:25:56 +0800
Message-ID: <78567AC4946EDC42B7DE978C350CD869EC5A1C@zch01exm26.fsl.freescale.net>
In-Reply-To: <9D668111-9774-4D45-944E-3C3C0EE47A09@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsldma: The MPC8377MDS board device tree node for fsldma driver
Thread-Index: AciQes6evI/yYyhXTW6ihxvJnGKC9QAADSlg
References: <1206517356-11209-1-git-send-email-wei.zhang@freescale.com> <1206517356-11209-2-git-send-email-wei.zhang@freescale.com> <e9c3a7c20803271237x1b2c3a2ci6837c5e2d5288c95@mail.gmail.com> <9D668111-9774-4D45-944E-3C3C0EE47A09@kernel.crashing.org>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>,
       "Dan Williams" <dan.j.williams@intel.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll send it to to. 

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> Sent: Friday, March 28, 2008 10:24 AM
> To: Dan Williams
> Cc: Zhang Wei; Andrew Morton; Linux Kernel; linuxppc-dev@ozlabs.org
> Subject: Re: [PATCH] fsldma: The MPC8377MDS board device tree 
> node for fsldma driver
> 
> 
> On Mar 27, 2008, at 2:37 PM, Dan Williams wrote:
> > On Wed, Mar 26, 2008 at 12:42 AM, Zhang Wei  
> > <wei.zhang@freescale.com> wrote:
> >> The fsldma driver is tested on MPC8377MDS board.
> >> The patch adds fsldma driver support into MPC8377MDS device tree.
> >>
> >> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> >> ---
> >>  arch/powerpc/boot/dts/mpc8377_mds.dts |   27 
> ++++++++++++++++++++++ 
> >> +++++
> >>  1 files changed, 27 insertions(+), 0 deletions(-)
> >
> > I think this patch should probably go through the powerpc tree, or
> > -mm.  I'll pick up the ones that touch either drivers/dma or
> > crypto/async_tx.
> 
> Can you resend and CC me.  I'll pick it up and push through via the  
> powerpc tree.
> 
> I want to make one update to the driver to support the 
> "proper" names  
> we document for compatible properties.
> 
> (uugh too many things to do)
> 
> - k
> 
