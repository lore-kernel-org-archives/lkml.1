Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbXILTxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbXILTxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 15:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXILTxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 15:53:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58347 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbXILTxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 15:53:41 -0400
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Chris Friesen <cfriesen@nortel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
In-Reply-To: <46E83B16.2070608@redhat.com>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
	 <46E6EE96.9060309@nortel.com> <46E6F2A8.2020104@pobox.com>
	 <46E83B16.2070608@redhat.com>
Content-Type: text/plain
Date: Wed, 12 Sep 2007 21:53:00 +0200
Message-Id: <1189626781.5597.2.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-09-12 at 15:16 -0400, Rik van Riel wrote:
> Jeff Garzik wrote:
> > Chris Friesen wrote:
> >> Randy Dunlap wrote:
> >>
> >>> +Thunderbird (GUI)
> >>> +
> >>> +By default, thunderbird likes to mangle text, but there are ways to
> >>> +coerce it into being nice.
> >>
> >> Can someone describe the problems with just attaching the patch in 
> >> Thunderbird?  It's what Martin says he does on the linked document...
> > 
> > Email clients don't like to quote attachments, even text/plain ones, 
> > which then makes attached patches much more difficult to review and 
> > comment on (i.e. you greatly reduce the number of reviewers).
> 
> Interestingly, Thunderbird does this right and simply
> adds text/plain attachments to the quoted text.
> 

Devolution allows the same, but most other mailers dont. Esp the text
based onces which are the majority under the people you want reviews
from.

