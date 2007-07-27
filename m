Return-Path: <linux-kernel-owner+w=401wt.eu-S933820AbXG0Tgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbXG0Tgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763336AbXG0Tgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:36:43 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4843 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762378AbXG0Tgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:36:41 -0400
Date: Fri, 27 Jul 2007 15:21:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [PATCH] Merge the Sonics Silicon Backplane subsystem
Message-ID: <20070727192120.GB7572@tuxdriver.com>
References: <200707271857.24162.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707271857.24162.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 06:57:20PM +0200, Michael Buesch wrote:
> The Sonics Silicon Backplane is a mini-bus used on
> various Broadcom chips and embedded devices.
> Devices using the SSB include b44, bcm43xx and various
> Broadcom based wireless routers.
> A b44 and bcm43xx port and a SSB based OHCI driver is available.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

At first glance it looks like there might be some tab/space issues
in some of the #define blocks toward the end of the patch, although
those might be intentional.

Aside from whatever other style issues that might be identified, I'll
state that this code has been carried in wireless-dev for months and
thereby also spent a lot of time in -mm as well as Fedora (rawhide
and F-7).  The code has proven to be reasonably stable and reliable.

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville
linville@tuxdriver.com
