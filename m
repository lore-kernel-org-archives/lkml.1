Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZF0Rw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZF0Rw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZF0RwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:52:17 -0400
Received: from genesysrack.ru ([195.178.208.66]:50695 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661AbZF0RwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:52:16 -0400
Date: Sat, 27 Jun 2009 21:52:09 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Patrick McHardy <kaber@trash.net>, Sam Ravnborg <sam@ravnborg.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] headers_check fix: linux/netfilter/xt_osf.h
Message-ID: <20090627175209.GA12453@ioremap.net>
References: <1246120264.32198.2.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246120264.32198.2.camel@hpdv5.satnam>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Jun 27, 2009 at 10:01:04PM +0530, Jaswinder Singh Rajput (jaswinder@kernel.org) wrote:
> fix the following 'make headers_check' warnings:
> 
>   usr/include/linux/netfilter/xt_osf.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Looks good, thank you.
Patrick, please apply.

-- 
	Evgeniy Polyakov
