Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZFGJHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZFGJHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZFGJHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:07:06 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36608 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZFGJHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:07:05 -0400
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Jun 2009 05:07:05 EDT
Date: Sun, 7 Jun 2009 18:41:38 +1000
From: Simon Horman <horms@verge.net.au>
To: Florian Fainelli <florian@openwrt.org>
Cc: Linux-MIPS <linux-mips@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] net/netfilter/ipvs/ip_vs_wrr.c: use lib/gcd.c
Message-ID: <20090607084137.GB8007@verge.net.au>
References: <200906041616.22786.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041616.22786.florian@openwrt.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 04:16:21PM +0200, Florian Fainelli wrote:
> This patch removes the open-coded version of the
> greatest common divider to use lib/gcd.c, the latter
> also implementing the a < b case.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Acked-by: Simon Horman <horms@verge.net.au>
