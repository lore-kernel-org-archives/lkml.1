Return-Path: <linux-kernel-owner+w=401wt.eu-S1030535AbXAaSiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030535AbXAaSiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030536AbXAaSiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:38:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2001 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030535AbXAaSiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:38:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=g9i1TU5ocK7GyOZFTgEVYrMW5eyFG7oOCWPYbtAd210joCjyG9O5nReB+gbZzhJhfO5iHe25Ep7XXxwqCOKkGbIKCCAjygvo411ZBw+R6Ayo2yJxbXgsuarzCQtTNoLnnglhGbkW8K/l7IevcYixL3tkegzbrDVd17Q4peV7hmY=
Message-ID: <b6c5339f0701311037l3971f11gad0d072e6c4cfcba@mail.gmail.com>
Date: Wed, 31 Jan 2007 13:37:58 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: Free Linux Driver Development!
Cc: "David Hollis" <dhollis@davehollis.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Trent Waddington" <trent.waddington@gmail.com>,
       "Dave Airlie" <airlied@gmail.com>, "Roland Dreier" <rdreier@cisco.com>,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0701311853390.13737@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com> <45BFA087.6020905@garzik.org>
	 <ada4pq8qjpd.fsf@cisco.com> <20070130214759.GA12477@kroah.com>
	 <adar6tcp43r.fsf@cisco.com>
	 <21d7e9970701301414s251b584mbee85ecd6909febf@mail.gmail.com>
	 <3d57814d0701301424m67d22cdbg7afc0a1dab29c152@mail.gmail.com>
	 <45BFC99A.8040805@garzik.org>
	 <1170250461.12914.33.camel@dhollis-lnx.sunera.com>
	 <Pine.LNX.4.61.0701311853390.13737@yvahk01.tjqt.qr>
X-Google-Sender-Auth: 42fcd554791298f6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Putting the "codingstyle" control aside, often it's because things look
> too hackish.

Also sometimes the authors know it's hackish, or just don't expect it
to be generally useful to the world.  I happen to own an out-of-tree
filesystem which I have little desire to have reviewed for mainline:
only a dozen people use it at most, and I know it would get pinged
mercilessly for using buffer heads and general insanity if it ever
made it past "use FUSE instead" (which would admittedly be a perfectly
fine response).  It works though, so I keep it up to date with the VFS
changes.

I do have some interest in working on various device drivers, though.
Greg, assuming this somehow kicks off some avalanche of specs, will
there be a ML for hooking up driver writers with specs and willing
users?

-- 
Bob Copeland %% www.bobcopeland.com
