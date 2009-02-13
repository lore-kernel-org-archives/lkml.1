Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbZBMJhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbZBMJhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZBMJhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:37:38 -0500
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:58598 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZBMJhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:37:38 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 04:37:38 EST
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: git-send-email
Date: Fri, 13 Feb 2009 10:34:05 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Junio C Hamano <gitster@pobox.com>,
       "L-K" <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1234451714.10603.22.camel@laptop> <20090212192104.GD15809@csclub.uwaterloo.ca> <1234477025.10603.38.camel@laptop>
In-Reply-To: <1234477025.10603.38.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131034.05814.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 February 2009, Peter Zijlstra wrote:
> > foobar patch 0 (usually a summary/overview)
> > +-foobar patch 1
> > +-foobar patch 2
> > +-foobar patch 3
> > +-foobar patch 4
> > +-foobar patch 5
> > 
> > is much nicer than
> > 
> > foobar patch 0
> > +-foobar patch 1
> >   +-foobar patch 2
> >     +-foobar patch 3
> >       +-foobar patch 4
> >         +-foobar patch 5
> > 
> > which seems to be what git does itself.
> 
> Which happens to be exactly what my suggestion would accomplish.

Ok, then I take back my reservations and support this idea.

Lennart: Thanks for visualizing what Peter meant :-)

Best Regards

Ingo Oeser
