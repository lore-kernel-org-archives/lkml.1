Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbXH1SEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbXH1SEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXH1SEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:04:40 -0400
Received: from c60.cesmail.net ([216.154.195.49]:40183 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbXH1SEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:04:40 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2007 14:04:39 EDT
Message-ID: <20070828135457.cp87tquqtc4w48sg@webmailbeta.spamcop.net>
Date: Tue, 28 Aug 2007 13:54:57 -0400
From: Pavel Roskin <proski@gnu.org>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, orinoco-users@lists.sourceforge.net,
       orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, hermes@gibson.dropbear.id.au,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [360/2many] MAINTAINERS - ORINOCO DRIVER
References: <46bffb31.f1XwyK4H0RsPvky8%joe@perches.com>
	<1188321322.2226.2.camel@dv> <1188321793.6062.40.camel@localhost>
In-Reply-To: <1188321793.6062.40.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Joe Perches <joe@perches.com>:

> On Tue, 2007-08-28 at 13:15 -0400, Pavel Roskin wrote:
>> NAK.  Please also add airport*, spectrum* and hermes* in the same
>> directory.
>
> Here's what I have now:
>
> ORINOCO/AIRPORT/SPECTRUM/HERMES WIRELESS DRIVERS
> P:	Pavel Roskin
> M:	proski@gnu.org
> P:	David Gibson
> M:	hermes@gibson.dropbear.id.au
> L:	linux-wireless@vger.kernel.org
> L:	orinoco-users@lists.sourceforge.net
> L:	orinoco-devel@lists.sourceforge.net
> W:	http://www.nongnu.org/orinoco/
> S:	Maintained
> F:	drivers/net/wireless/orinoco*
> F:	drivers/net/wireless/airport*
> F:	drivers/net/wireless/spectrum*
> F:	drivers/net/wireless/hermes*

Signed-off-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
