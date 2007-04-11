Return-Path: <linux-kernel-owner+w=401wt.eu-S1030811AbXDKEzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030811AbXDKEzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030816AbXDKEzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:55:12 -0400
Received: from koto.vergenet.net ([210.128.90.7]:33236 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030811AbXDKEzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:55:10 -0400
Date: Wed, 11 Apr 2007 13:55:03 +0900
From: Simon Horman <horms@verge.net.au>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Wensong Zhang <wensong@linux-vs.org>, Julian Anastasov <ja@ssi.bg>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH 17/30] Use menuconfig objects - IPVS
Message-ID: <20070411045501.GD15641@verge.net.au>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704102323370.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704102323370.32056@yvahk01.tjqt.qr>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 11:25:59PM +0200, Jan Engelhardt wrote:
> 
> Use menuconfigs instead of menus, so the whole menu can be disabled at        
> once instead of going through all options.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

This seems to work fine to me.

Signed-off-by: Simon Horman <horms@verge.net.au>

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

