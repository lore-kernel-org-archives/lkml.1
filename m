Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZBNV34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZBNV34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZBNV3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:29:49 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:8087 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZBNV3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EVHptF1RgPD6yS1W2qwkXBBwXKJTV3wpl7le5bDURqq6Sa+h99i827CP0PBbSOtiUh
         8YLpKTu5fJ/lDXNiZd1N7uh+9JgLCZJTrhMl9rhT8iq0UnhVhd9d0xohZO8uhyBzzUND
         sK7gumtgqdRrqT6LZy4ghd0JTTpXkY3AcyDx8=
Date: Sun, 15 Feb 2009 00:29:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hannes Eder <hannes@hanneseder.net>
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/43] drivers/net/ppp*.c: fix sparse warnings: fix
	signedness
Message-ID: <20090214212948.GE7648@localhost>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net> <20090214211346.23489.96321.stgit@vmbox.hanneseder.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090214211346.23489.96321.stgit@vmbox.hanneseder.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hannes Eder - Sat, Feb 14, 2009 at 10:13:52PM +0100]
| Fix this sparse warnings:
|   drivers/net/ppp_generic.c:919:43: warning: incorrect type in argument 1 (different signedness)
|   drivers/net/pppoe.c:1195:43: warning: incorrect type in argument 1 (different signedness)
|   drivers/net/pppol2tp.c:2666:43: warning: incorrect type in argument 1 (different signedness)
| 
| Signed-off-by: Hannes Eder <hannes@hanneseder.net>
...

Thanks Hannes,

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

	- Cyrill -
