Return-Path: <linux-kernel-owner+w=401wt.eu-S969339AbXEICT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969339AbXEICT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbXEICTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:19:16 -0400
Received: from vena.lwn.net ([206.168.112.25]:60388 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbXEICTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:19:16 -0400
X-Greylist: delayed 1903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2007 22:19:16 EDT
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH] doc: volatile considered evil 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 08 May 2007 12:14:04 PDT."
             <20070508121404.17bd97a6.randy.dunlap@oracle.com> 
Date: Tue, 08 May 2007 19:47:31 -0600
Message-ID: <16987.1178675251@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Here are some 'volatile' comments from Linus, extracted from
> several emails in at least 2 threads.
> 
> If this is close to useful, we can add it to Documentation/.

I just took a shot at turning this into something more like a normal
document:

	http://lwn.net/Articles/233479/

Comments welcome.  If people think it suits the need I'll happily make a
version which moves from the LWN style to Documentation/ and send it in.

Thanks,

jon

Jonathan Corbet / LWN.net / corbet@lwn.net
