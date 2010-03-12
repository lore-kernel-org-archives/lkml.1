Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0CLLFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 06:05:11 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:3930 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364Ab0CLLFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 06:05:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAH+tmUvCTtAn/2dsb2JhbACaa3O6GoR7BA
Date: Fri, 12 Mar 2010 12:04:53 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] Re: [PATCH v2] m68knommu: driver for Freescale
	Coldfire I2C controller.
Message-ID: <20100312110453.GA16156@frolo.macqel>
References: <201001101600.41932.sfking@fdwdc.com> <201001111024.05506.sfking@fdwdc.com> <20100124151519.GB28675@fluff.org.uk> <201001251156.31110.sfking@fdwdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001251156.31110.sfking@fdwdc.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Mon, Jan 25, 2010 at 11:56:30AM -0800, Steven King wrote:
> > >
> > > Add support for the I2C controller used on Freescale/Motorola Coldfire
> > > MCUs.
> > >
> > > Signed-off-by: Steven King <sfking@fdwdc.com>

What's the status of this ?

I need to use i2c for a coldfire uclinux project (with a mcf5484) and I
now have 3 different coldfire i2c drivers, none of which is in mainline.

i2c-mcf.c (from uClinux-dist-20090618, but not in http://git.kernel.org/?p=linux/kernel/git/gerg/m68knommu.git;a=summary)
i2c-mcf548x.c (from ltib-m5475evb-20080808, found as "Linux BSP for MCF5484LITE, MCF5475/85EVB" at http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=MCF548X&fpsp=1&tab=Design_Tools_Tab)
i2c-coldfire.c (from http://lkml.org/lkml/2010/1/11/165)

I like to work with mainline sources to be be able to contribute to and benefit
from collective work.

Which one has the best chances to be put in mainline ?

Best regards

Philippe
