Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbXILXJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbXILXJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbXILXJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:09:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49748 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756861AbXILXJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:09:26 -0400
Date: Thu, 13 Sep 2007 01:09:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Jeff Garzik <jgarzik@pobox.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
Message-ID: <20070912230935.GE3563@stusta.de>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com> <46E6EE96.9060309@nortel.com> <46E6F2A8.2020104@pobox.com> <46E83B16.2070608@redhat.com> <1189626781.5597.2.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1189626781.5597.2.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 09:53:00PM +0200, Peter Zijlstra wrote:
> 
> On Wed, 2007-09-12 at 15:16 -0400, Rik van Riel wrote:
> > Jeff Garzik wrote:
> > > Chris Friesen wrote:
> > >> Randy Dunlap wrote:
> > >>
> > >>> +Thunderbird (GUI)
> > >>> +
> > >>> +By default, thunderbird likes to mangle text, but there are ways to
> > >>> +coerce it into being nice.
> > >>
> > >> Can someone describe the problems with just attaching the patch in 
> > >> Thunderbird?  It's what Martin says he does on the linked document...
> > > 
> > > Email clients don't like to quote attachments, even text/plain ones, 
> > > which then makes attached patches much more difficult to review and 
> > > comment on (i.e. you greatly reduce the number of reviewers).
> > 
> > Interestingly, Thunderbird does this right and simply
> > adds text/plain attachments to the quoted text.
> 
> Devolution allows the same, but most other mailers dont. Esp the text
> based onces which are the majority under the people you want reviews
> from.

I still prefer patches directly inline, but mutt both is a text based 
MUA and defaults to adding text/plain attachments to the quoted text.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

