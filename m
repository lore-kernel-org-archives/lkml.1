Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXFZKNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXFZKNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXFZKNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:13:15 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:53851 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbXFZKNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:13:14 -0400
Date: Tue, 26 Jun 2007 12:16:39 +0200
From: DervishD <lkml@dervishd.net>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Message-ID: <20070626101639.GB20178@DervishD>
Mail-Followup-To: Matthieu CASTET <castet.matthieu@free.fr>,
	linux-kernel@vger.kernel.org
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706221626.39969.ak@suse.de> <20070622094429.0910c7cb.randy.dunlap@oracle.com> <200706221923.02736.ak@suse.de> <20070622132810.3c758590.randy.dunlap@oracle.com> <E1I2159-0005AH-DS@flower> <20070623104303.a186c5a8.randy.dunlap@oracle.com> <pan.2007.06.23.20.24.29@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <pan.2007.06.23.20.24.29@free.fr>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Matthieu :)

 * Matthieu CASTET <castet.matthieu@free.fr> dixit:
> On Sat, 23 Jun 2007 10:43:03 -0700, Randy Dunlap wrote:
> 
> > OTOH, you also didn't supply a patch.  If you do this, I'll be glad to
> > consider it.  If I can read it, that is.
> 
> "s|/bin/sh|/bin/bash" is so hard to do ?

    Given that it happens too with "ldd", it really *is* that hard. I
don't know why still people think that /bin/sh is always /bin/bash. If
they want/need bash, that's ok to me, I will have it installed for such
tasks, but they should call it "#!/bin/bash".

    It seems easier to say "get a real shell" (as if Bash was the only
real shell) than fixing that bug...

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
