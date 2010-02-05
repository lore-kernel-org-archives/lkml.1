Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0BEOeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:34:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:57392 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756567Ab0BEOep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:34:45 -0500
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jamal Hadi Salim <hadi@cyberus.ca>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 05 Feb 2010 15:34:41 +0100
From: "Randolf Pohl" <randolf.pohl@gmx.de>
Message-ID: <20100205143441.280460@gmx.net>
MIME-Version: 1.0
Subject: Re: [46/74] net: restore ip source validation
To: Sven Joachim <svenjoac@gmx.de>
X-Authenticated: #47769897
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18rhkZ2FFsrpil5OaGyjhDNsz0nB7mAYUErrY8Z+i
 s4xXJNKmgHgw8OXAXt+beJIfrWgj0+u8hWrw== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: s1ZZI+UHZDIrE0faomQ2o995emhmY4F0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -490,6 +490,7 @@ enum
>  	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
>  	NET_IPV4_CONF_ARP_ACCEPT=21,
>  	NET_IPV4_CONF_ARP_NOTIFY=22,
> +	NET_IPV4_CONF_SRC_VMARK=24,
>  	__NET_IPV4_CONF_MAX
>  };
> 

Must these be contiguous, i.e. 23?

R.
-- 
Jetzt kostenlos herunterladen: Internet Explorer 8 und Mozilla Firefox 3.5 -
sicherer, schneller und einfacher! http://portal.gmx.net/de/go/atbrowser
