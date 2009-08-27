Return-Path: <linux-kernel-owner+w=401wt.eu-S1751407AbZH0G7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbZH0G7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 02:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZH0G7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 02:59:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60011 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZH0G7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 02:59:08 -0400
Date: Wed, 26 Aug 2009 23:58:56 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: mm <mmi@superbash.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>, r.marek@assembler.cz
Subject: Re: AMD K10 temp.module ready since months, but missing in
 kernel...
In-Reply-To: <20090827011019.59655f23@phenom>
Message-ID: <alpine.DEB.2.01.0908262355340.5744@bogon.housecafe.de>
References: <20090821001322.470bb177@p4laptop> <20090821104533.GA3872@liondog.tnic> <alpine.DEB.2.01.0908261314300.5744@bogon.housecafe.de> <20090827011019.59655f23@phenom>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX187ty02CfNk+yps91MFfpJjXUnIszWBawq2Asv
 4Wjyo584nSmzKxcj3Z/LVa/YksK2NqwghDNHpr8hAhz9L7mXkK
 f74yESTO63QabB4RDsmwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 at 01:10, mm wrote:
> Am Wed, 26 Aug 2009 13:15:45 -0700 (PDT) haben Sie (Christian Kujau
> <lists@nerdbynature.de>) geschrieben:
> > On Fri, 21 Aug 2009 at 12:45, Borislav Petkov wrote:
> > > On Fri, Aug 21, 2009 at 12:13:22AM +0200, mmi wrote:
> > > > Hello out there,
> > > > 
> > > > i found the code to read temperature of AMD K10 (Phenom)
> > > > processors a couple of months ago in the net (GPL). I use it
> > > > since January now and i wonder, why it's not in the kernel till
> > > > now.
> > > > 
> > > > It's from the same author, who wrote k8temp.c (which is in
> > > > kernel).
> > 
> > MMI, do you mean this:
> > http://linux.derkeiler.com/Newsgroups/alt.os.linux/2008-08/msg00398.html
> > 
> > ...or which code are you referring to?
> > 
> > Christian.
> 
> YES, i refer to the code of Rudolf Marek. I think, he also has written
> the k8tmp.c. So he and his code should be well known in main line.
> 
> In the meanwhile i read a discussion where  Rudolf 
> thinks that it's not working on all Phenoms. Probably a problem on first
> series of Phenom I.
> 
> I tested it on latest Phenom I and since January on Phenom II, it works
> fine.

Well, it's Rudolf's code - if he thinks this code is ready for inclusion 
as well, we'd need his Signed-off to do so....

C.
-- 
BOFH excuse #213:

Change your language to Finnish.
