Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYIYVFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYIYVFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYIYVEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:04:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:64503 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbYIYVEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:04:54 -0400
Message-ID: <48DBFCDD.5090908@oracle.com>
Date: Thu, 25 Sep 2008 14:04:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Paul Mundt <lethal@linux-sh.org>, Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
References: <20080924230054.GA27730@suse.de> <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com> <20080925020608.GA13869@suse.de> <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com> <20080925052725.GA5739@linux-sh.org> <20080925074923.4845005b.randy.dunlap@oracle.com> <20080925105320.ef70065b.randy.dunlap@oracle.com> <20080925204800.GA11225@suse.de>
In-Reply-To: <20080925204800.GA11225@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> ISTM that the real problems are (a) it's easier to introduce new staging/crap
>> than it is to fix EXPERIMENTAL and (b) no one wants to try to fix EXPERIMENTAL.
> 
> The whole EXPERIMENTAL issue hasn't come up in years, I'm supprised that
> people even consider it a valid option these days.
> 
> I'm all for fixing it up, but as Paul so well described, the code I'm
> talking about is WAY worse than a mere "experimental" marking, it needs
> to be explicitly pointed out that this is not even up to that level at
> all.
> 
> And as was also pointed out, the EXPERIMENTAL marking cleanup is totally
> orthogonal to the main goal here, and that is getting code into the tree
> that is not up to our "normal" merge quality levels, in order to get a
> wider audience of users and developers working on it, and using it.
> 
> Hey, if people want me to name it TAINT_GREGKH, I can do that, I thought
> I was being nice by picking TAINT_CRAP...

I don't disagree with the CRAP name... fwiw.
I think that we have enough quality problems without adding crap.

-- 
~Randy
