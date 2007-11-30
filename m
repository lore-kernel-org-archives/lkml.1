Return-Path: <linux-kernel-owner+w=401wt.eu-S935366AbXK3RNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935366AbXK3RNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935539AbXK3RNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:13:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50138 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675AbXK3RNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:13:06 -0500
Subject: Re: [PATCH 9/9] MN10300: Fix MTD JEDEC probe so that the ASB2303
	bootprom can be detected [2.6.24-rc3-mm2]
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: tharbaugh@plug.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org, ben-mtd@fluff.org
In-Reply-To: <28258.1196431276@redhat.com>
References: <1196430400.13978.26.camel@pmac.infradead.org>
	 <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
	 <20071129225301.21536.91506.stgit@warthog.procyon.org.uk>
	 <28258.1196431276@redhat.com>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 17:12:56 +0000
Message-Id: <1196442776.13978.43.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You made me look at datasheets which number address lines from A-1 to
A18. My brain hurts. I hate you now.

Please try git://git.infradead.org/~dwmw2/jedec-unlock.git 

I may have broken chip probing for a number of people now, but it ought
to be progress.

-- 
dwmw2

