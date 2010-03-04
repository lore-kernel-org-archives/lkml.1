Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0CDLkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 06:40:17 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:50693 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab0CDLkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 06:40:16 -0500
X-IronPort-AV: E=Sophos;i="4.49,580,1262563200"; 
   d="scan'208";a="9778008"
Date: Thu, 4 Mar 2010 11:44:04 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: =?ISO-8859-15?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2 of 4] Linux pvops: early PV on HVM
In-Reply-To: <20100304093237.GS2761@reaktio.net>
Message-ID: <alpine.DEB.2.00.1003041142300.24752@kaball-desktop>
References: <alpine.DEB.2.00.1003021734440.22259@kaball-desktop> <20100304093237.GS2761@reaktio.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-950488939-1267703044=:24752"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-950488939-1267703044=:24752
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT

On Thu, 4 Mar 2010, Pasi Kärkkäinen wrote:
> On Tue, Mar 02, 2010 at 06:30:18PM +0000, Stefano Stabellini wrote:
> > Hi all,
> > this patch is derived from an earler version of the patch named "Xen PV
> > extension of HVM initialization" in Shen's patch series.
> > This patch:
> > 
> > - initializes basic pv on hvm features in xen_guest_init; 
> > 
> 
> Are you planning to make pv-on-hvm disk/net frontends also
> work for HVM guests running 2.6.3x pvops kernels? 
> 

Yes, that what I meant.
Even though many things are still missing in the patch series, this
feature works already in last version I sent.

--8323329-950488939-1267703044=:24752--
