Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbXJHSRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbXJHSRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXJHSQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:16:58 -0400
Received: from gw.goop.org ([64.81.55.164]:35625 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbXJHSQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:16:58 -0400
Message-ID: <470A73E9.4080504@goop.org>
Date: Mon, 08 Oct 2007 11:16:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, Sam Ravnborg <sam@ravnborg.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
References: <25555.1191864285@lwn.net>	<20071008173706.GA12026@uranus.ravnborg.org>	<Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr>	<470A708D.4080905@goop.org> <20071008110614.dd671fc7.randy.dunlap@oracle.com>
In-Reply-To: <20071008110614.dd671fc7.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> but Tested-by: doesn't have to involve any "actually looking at/reading
> the patch."  Right?
>
> IOW, the patch could be ugly as sin but it works...
>   

Sure, absolutely.  I never said its a substitute for review.  An ugly
working patch is useful, because its the raw material for a nice working
patch.  A nice non-working patch can be framed and admired from a
distance, but it isn't terribly useful.

    J
