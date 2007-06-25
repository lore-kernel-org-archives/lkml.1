Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbXFYSF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbXFYSF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXFYSFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:05:49 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48885 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXFYSFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:05:49 -0400
Date: Mon, 25 Jun 2007 20:05:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, kunai@linux-foundation.jp,
       tim.bird@am.sony.com, gh@us.ibm.com, arjan@infradead.org,
       jengelh@computergmbh.de, hpa@zytor.com, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: Documentation of kernel messages (Summary)
Message-ID: <20070625180557.GA12937@uranus.ravnborg.org>
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613111549.db1fa4d9.akpm@linux-foundation.org> <1182779321.7142.15.camel@localhost.localdomain> <200706251144.48658.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706251144.48658.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I find "document messages" to be a horrible idea conceptually, because I think 
> the messages should _be_ documentation.  If the message is unclear it should 
> be clarified.  "There's too much garbage on the floor, we should laminate it 
> so we can't smell it anymore."  Er, no...

"Document message" is for the cases where the message itself does not convey
enough info.
No need to add more text when the initial message is good enough.

	Sam
