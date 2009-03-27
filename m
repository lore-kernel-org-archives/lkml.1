Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbZC0JUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbZC0JUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbZC0JT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:19:58 -0400
Received: from mail.us.es ([193.147.175.20]:44911 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753986AbZC0JT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:19:57 -0400
Message-ID: <49CC9A32.3060303@netfilter.org>
Date: Fri, 27 Mar 2009 10:19:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060812)
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] iptables: "cluster" match uses IPv6-specific code without
 ifdef
References: <1238100203-23454-1-git-send-email-steven@uplinklabs.net>
In-Reply-To: <1238100203-23454-1-git-send-email-steven@uplinklabs.net>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Noonan wrote:
> The symbol __ipv6_addr_type is only available with CONFIG_IPV6 or
> CONFIG_IPV6_MODULE.

Please, CC netfilter-devel for netfilter-related issues. Patrick, I'm
fine with this, can you apply this patch?

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
