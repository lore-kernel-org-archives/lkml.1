Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYFRReR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYFRReR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYFRReH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:34:07 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60914 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYFRReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:34:06 -0400
Subject: Re: [Ksummit-2008-discuss] Request for discussion on when to
	merge	drivers
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "ksummit-2008-discuss@lists.linux-foundation.org" 
	<ksummit-2008-discuss@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3061C5FA5@orsmsx505.amr.corp.intel.com>
References: <1213802866.3515.24.camel@localhost.localdomain>
	 <57C9024A16AD2D4C97DC78E552063EA3061C5FA5@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 12:34:01 -0500
Message-Id: <1213810441.3515.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 10:15 -0700, Luck, Tony wrote:
> > Experience has shown that for most SCSI drivers, the authors tend to be
> > the people producing the hardware and without documentation, no-one else
> > can fix up anything other than obvious coding errors, so we can't put it
> > in the tree and hope someone else will fix it if they have a problem.
> 
> Is there an opportunity for a carrot here ... a driver submitted
> *with documentation* gets a faster path into the tree?

You mean with actual how to program it information?  er dunno ... never
seen one of those ...

But I suppose, theoretically, since anyone could access the
documentation to maintain it, it would be much more likely to be fixed
up in tree, yes.

James


