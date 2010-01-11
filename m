Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246Ab0AKKyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0AKKyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946Ab0AKKyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:54:22 -0500
Received: from stinky.trash.net ([213.144.137.162]:59919 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0AKKyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:54:21 -0500
Message-ID: <4B4B0356.9080006@trash.net>
Date: Mon, 11 Jan 2010 11:54:14 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Wensong Zhang <wensong@linux-vs.org>, Julian Anastasov <ja@ssi.bg>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 6/8] net/netfilter/ipvs/ip_vs_ftp.c: Use standardized
 format in sprintf
References: <cover.1262726222.git.joe@perches.com> <da25f48ee7959e83a18e3705c223c8619e508bf4.1262726222.git.joe@perches.com> <20100106023416.GB18557@verge.net.au>
In-Reply-To: <20100106023416.GB18557@verge.net.au>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> On Tue, Jan 05, 2010 at 05:20:18PM -0800, Joe Perches wrote:
>> Use the same format string as net/ipv4/netfilter/nf_nat_ftp.c
>> to encode an ipv4 address and port.
>>
>> Both uses should be a single common function.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
> 
> Acked-by: Simon Horman <horms@verge.net.au>

Applied, thanks.
