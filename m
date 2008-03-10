Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbYCJHWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbYCJHWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 03:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbYCJHWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 03:22:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:51643 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750761AbYCJHWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 03:22:32 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18ngNwyjWUn/KZ4u6Ak5U0XO6CWF8u8riuVUW8E2R
	V/SY6bWkO1w5xI
Date: Mon, 10 Mar 2008 08:22:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Tejun Heo <htejun@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: Unknown SATA PIIX PCI device ID 0x29b6
In-Reply-To: <47D485EC.1060103@gmail.com>
Message-ID: <Pine.LNX.4.64.0803100821440.3948@axis700.grange>
References: <Pine.LNX.4.64.0802282306190.10087@axis700.grange>
 <20080228225603.2764bfd1@core> <Pine.LNX.4.64.0802290010320.10498@axis700.grange>
 <47CFADDF.20200@gmail.com> <Pine.LNX.4.64.0803061248070.5670@axis700.grange>
 <47D0C9E6.8090301@gmail.com> <Pine.LNX.4.64.0803082345000.6749@axis700.grange>
 <47D3723B.3040700@gmail.com> <Pine.LNX.4.64.0803092221560.7385@axis700.grange>
 <47D485EC.1060103@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, Tejun Heo wrote:

> > Yctually it was 2.6.24 before, rebuilt 2.6.25-rc4, booted as above, it did 
> > say:
> > 
> > ata4: FORCE: PHY spd limit set to 1.5Gbps
> > 
> > but hot-plugging the drive still took 50 seconds to recover.
> 
> How about cold plugging?

Same.

Thanks
Guennadi
---
Guennadi Liakhovetski
