Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbZE1GlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbZE1GlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZE1Gkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:40:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58643 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZE1Gkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:40:52 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>
Date: Thu, 28 May 2009 12:10:33 +0530
Subject: RE: linux-next: manual merge of the omap tree with the arm tree
Thread-Topic: linux-next: manual merge of the omap tree with the arm tree
Thread-Index: AcnfXnTPQgaOCSspQe+SE5zxOvYxsAAAKKAA
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02B4BE3967@dbde02.ent.ti.com>
References: <20090528143138.2de9ad37.sfr@canb.auug.org.au>
	<EAF47CD23C76F840A9E7FCE10091EFAB02B4BE3927@dbde02.ent.ti.com>
 <20090528163453.641e5ea3.sfr@canb.auug.org.au>
In-Reply-To: <20090528163453.641e5ea3.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
> Sent: Thursday, May 28, 2009 12:05 PM
> To: Shilimkar, Santosh
> Cc: Tony Lindgren; linux-omap@vger.kernel.org; 
> linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Russell King
> Subject: Re: linux-next: manual merge of the omap tree with 
> the arm tree
> 
> Hi,
> 
> On Thu, 28 May 2009 11:55:09 +0530 "Shilimkar, Santosh" 
> <santosh.shilimkar@ti.com> wrote:
> >
> > >  +machine-$(CONFIG_ARCH_OMAP2)		:= omap2
> > >  +machine-$(CONFIG_ARCH_OMAP3)		:= omap2
> > > ++machine-$(CONFIG_ARCH_OMAP4)		:= omap2
> > 
> > ++ Is this really ok ?
> 
> Yeah, this is a diff of a git merge.  The ++ just means it 
> was added on
> neither side of the merge - I modified the change from the omap tree
> slightly to fit in better with the cleanups from the arm tree.
Ok. Thanks !!

Regards,
Santosh
 