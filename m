Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYIZUjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYIZUjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYIZUjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:39:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59837 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYIZUjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:39:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48DD4867.4060009@s5r6.in-berlin.de>
Date: Fri, 26 Sep 2008 22:39:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
References: <20080924230054.GA27730@suse.de> <20080925020608.GA13869@suse.de>	 <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com>	 <20080925042108.GA3931@suse.de>	 <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>	 <20080925205328.GB11225@suse.de>	 <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com>	 <20080925220454.GA12116@suse.de>	 <f7848160809251522s4e589b9eu7a4fc9566d2b25e9@mail.gmail.com>	 <48DD2BA3.7050808@s5r6.in-berlin.de> <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com>
In-Reply-To: <f7848160809261311q487493d1pea4e953dd98f881@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> Just name the staging modules with _stg prefix like I said - easier to
> spot _stg in the module list than decoding the taint.
...
> It is nice to not have to change core kernel code and annoy users with
> warnings

Yes, let's annoy them with weird name changes instead.

(Seems you never communicate with users and never document something.)
-- 
Stefan Richter
-=====-==--- =--= ==-=-
http://arcgraph.de/sr/
