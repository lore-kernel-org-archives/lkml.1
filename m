Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYIYVwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYIYVwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYIYVv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:51:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39768 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbYIYVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:51:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48DC07E0.5090007@s5r6.in-berlin.de>
Date: Thu, 25 Sep 2008 23:51:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Greg KH <gregkh@suse.de>, Paul Mundt <lethal@linux-sh.org>,
       Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
References: <20080924230054.GA27730@suse.de> <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com> <20080925020608.GA13869@suse.de> <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com> <20080925052725.GA5739@linux-sh.org> <20080925074923.4845005b.randy.dunlap@oracle.com> <20080925105320.ef70065b.randy.dunlap@oracle.com> <20080925204800.GA11225@suse.de> <48DBFCDD.5090908@oracle.com>
In-Reply-To: <48DBFCDD.5090908@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>>> ISTM that the real problems are (a) it's easier to introduce new staging/crap
>>> than it is to fix EXPERIMENTAL and (b) no one wants to try to fix EXPERIMENTAL.
...
> I don't disagree with the CRAP name... fwiw.
> I think that we have enough quality problems without adding crap.

True.  OTOH many if not most of the -staging drivers are ones which are 
already in use.  Their users already deal with whatever quality problems 
these drivers have, in addition to having to fight with the installation 
hassles that are inherent to out-of-tree drivers.
-- 
Stefan Richter
-=====-==--- =--= ==--=
http://arcgraph.de/sr/
