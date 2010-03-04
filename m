Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0CDJck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:32:40 -0500
Received: from reaktio.net ([194.89.68.22]:47448 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab0CDJcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:32:36 -0500
Date: Thu, 4 Mar 2010 11:32:37 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 2 of 4] Linux pvops: early PV on HVM
Message-ID: <20100304093237.GS2761@reaktio.net>
References: <alpine.DEB.2.00.1003021734440.22259@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003021734440.22259@kaball-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 06:30:18PM +0000, Stefano Stabellini wrote:
> Hi all,
> this patch is derived from an earler version of the patch named "Xen PV
> extension of HVM initialization" in Shen's patch series.
> This patch:
> 
> - initializes basic pv on hvm features in xen_guest_init; 
> 

Are you planning to make pv-on-hvm disk/net frontends also
work for HVM guests running 2.6.3x pvops kernels? 

-- Pasi

