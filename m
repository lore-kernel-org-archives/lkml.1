Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZBFPAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZBFPAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZBFO7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:59:54 -0500
Received: from ns1.suse.de ([195.135.220.2]:50294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbZBFO7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:59:53 -0500
Message-ID: <498C5053.4010809@suse.de>
Date: Fri, 06 Feb 2009 15:59:31 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Frank Seidel <frank@f-seidel.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       herbert@gondor.apana.org.au, jarod@redhat.com
Subject: Re: [PATCH] crypto: add missing KERN_* constants to printks
References: <498C46DE.8040700@suse.de> <20090206145838.GA28197@x200.localdomain> <498C4F2E.1070204@f-seidel.de> <20090206150315.GA28249@x200.localdomain>
In-Reply-To: <20090206150315.GA28249@x200.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan schrieb:
> Some messages there were truly debugging and some clearly weren't
> WARNING, but INFO.

Yes, i also thought so, but i didn't venture to change it
to i think it looks like. And as bevor they also were all at
the same (unspecified/default) level...
Do you think its worth/i should redo it and adapt the loglevel
more appropriate?

Thanks,
Frank

