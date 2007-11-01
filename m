Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXKACdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXKACdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 22:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbXKACdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 22:33:31 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:55686 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXKACda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 22:33:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ucc_geth: add support for netpoll
Date: Thu, 1 Nov 2007 10:33:24 +0800
Message-ID: <989B956029373F45A0B8AF0297081890019B642A@zch01exm26.fsl.freescale.net>
In-Reply-To: <20071031215903.GA1287@zarina>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ucc_geth: add support for netpoll
Thread-Index: AcgcCZ4oyVNzWoAuQC+9RMp5seRlUwAJWZog
References: <20071011124842.GB13963@localhost.localdomain> <4723389F.7010109@ru.mvista.com> <20071027143731.GA2616@zarina> <989B956029373F45A0B8AF0297081890019B61BF@zch01exm26.fsl.freescale.net> <20071029121744.GA20372@localhost.localdomain> <20071031215903.GA1287@zarina>
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: <cbou@mail.ru>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Anton Vorontsov [mailto:cbou@mail.ru] 
> Sent: Thursday, November 01, 2007 5:59 AM
> To: Li Yang-r58472
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; 
> linuxppc-dev@ozlabs.org
> Subject: Re: [PATCH] ucc_geth: add support for netpoll
> 
> On Mon, Oct 29, 2007 at 03:17:44PM +0300, Anton Vorontsov wrote:
> [...]
> > > Oops.  The original patch happened to hit the Junk mail box. :(
> > 
> > That one as well? http://lkml.org/lkml/2007/10/11/128
> > 
> > > I think
> > > the patch is good to merge after the cosmetic change.  I 
> can do it 
> > > in next pull request to Jeff.
> > 
> > Ok, great. Thanks.
> 
> I'm wondering if you missed that email again. Maybe your mail 
> client/server doing weird things with emails from @ru.mvista.com?

No.  I have explicitly add you to the whitelist. :) Please be patient,
isn't this patch a new feature which can only be integrated in the merge
window?  Thanks.

- Leo
