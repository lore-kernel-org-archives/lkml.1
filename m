Return-Path: <linux-kernel-owner+w=401wt.eu-S1762688AbYF0UBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbYF0UBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbYF0UAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:00:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:31422 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbYF0UAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bwB5x9QWI3xro7d2HowP5ll7sJgc5Edkr0M1Tq/HGqn8I4QGoXF97jqc3yEWcuXwq4
         YZtiaTmK+pGf4nhDj8jiWE6H5iikAmVDM9fdOUqEQxwAQYvLNHGq3DA7/W6kCgZjZSX5
         XNQzpZwXvnTVe0vB7Y3pSy+POQV5bGp/u6I0k=
Date: Sat, 28 Jun 2008 00:00:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chris Friesen <cfriesen@nortel.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: nmi_watchdog - documentation fix
Message-ID: <20080627200020.GG18957@cvg>
References: <20080627154340.GC18957@cvg> <Pine.LNX.4.55.0806271652020.8868@cliff.in.clinika.pl> <20080627165937.2f1fb661@lxorguk.ukuu.org.uk> <4865160C.2040403@nortel.com> <20080627165125.GE18957@cvg> <20080627203204.2bdd7aed@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627203204.2bdd7aed@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alan Cox - Fri, Jun 27, 2008 at 08:32:04PM +0100]
| > > The following sounds better to me: "In kernels prior to 2.4.2-ac18 the 
| > > NMI-oopser is enabled..."  In this context the phrase itself is in the 
| > > present, but we point to past kernels.
| 
| Agreed.
| 
| > And the winner is? I'm not native English speaker so I can't select
| > a better candidate in {is,was} limited set.
| 
| The suggestion above.
| 
| Alan
| 

Thanks Alan, I've already sent the updated version. Hope
you will find it in your mbox /I thought I've Cc'ed you/ ;)

		- Cyrill -
