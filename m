Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbXFLN1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbXFLN1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbXFLN1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:27:30 -0400
Received: from [198.99.130.12] ([198.99.130.12]:51394 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbXFLN13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:27:29 -0400
Date: Tue, 12 Jun 2007 09:26:52 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UML: fix missing non-blocking I/O, now DEBUG_SHIRQ works
Message-ID: <20070612132652.GA5267@c2.user-mode-linux.org>
References: <1181512917.3157.8.camel@localhost> <20070611173154.GA6889@c2.user-mode-linux.org> <466DA50C.5050301@aladin.ro> <20070611211604.GA8859@c2.user-mode-linux.org> <466DCF1D.9050508@aladin.ro> <20070612004804.GA9871@c2.user-mode-linux.org> <466E32C5.70105@aladin.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466E32C5.70105@aladin.ro>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 08:44:37AM +0300, Eduard-Gabriel Munteanu wrote:
> Okay, I don't have an x86_64, sparc64 or something similar, as my 
> computer is an x86, so I can't contradict this. If everything is fine on 
> such arches, no fix is needed when nothing's broken... though I still 
> think it's kind of ugly (though it's somehow ingenious as a hack) :)

Yeah, I would agree with that.

> Do you want me to resubmit the patch without these changes? I'll be back 
> in a few hours (got to go now) and trim this out from the patch if 
> that's necessary.

I have it in my tree now, without that set of changes.  If you want to
make the change yourself, send me a new patch, and I'll use it.
Otherwise, I'll stick with what I have now.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
