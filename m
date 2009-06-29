Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZF2M3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZF2M3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZF2M3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:29:08 -0400
Received: from stinky.trash.net ([213.144.137.162]:35839 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZF2M3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:29:07 -0400
Message-ID: <4A48B390.3040100@trash.net>
Date: Mon, 29 Jun 2009 14:29:04 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Evgeniy Polyakov <zbr@ioremap.net>, Sam Ravnborg <sam@ravnborg.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] headers_check fix: linux/netfilter/xt_osf.h
References: <1246120264.32198.2.camel@hpdv5.satnam>
In-Reply-To: <1246120264.32198.2.camel@hpdv5.satnam>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> fix the following 'make headers_check' warnings:
> 
>   usr/include/linux/netfilter/xt_osf.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 

Applied, thanks.
