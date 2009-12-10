Return-Path: <linux-kernel-owner+w=401wt.eu-S1760478AbZLJJ4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760478AbZLJJ4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 04:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759467AbZLJJ4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 04:56:40 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:26433 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759436AbZLJJ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 04:56:38 -0500
X-Trace: 304048899/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.50.63/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.50.63
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYBAH5UIEtPRTI//2dsb2JhbAAIhB3BIJAag1lTBA
X-IronPort-AV: E=Sophos;i="4.47,374,1257120000"; 
   d="scan'208";a="304048899"
Date: Thu, 10 Dec 2009 09:56:36 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: An mm bug in today's 2.6.32 git tree
In-Reply-To: <2375c9f90912092259pe86356cvb716232ba7a4d604@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0912100951130.31654@sister.anvils>
References: <2375c9f90912090238u7487019eq2458210aac4b602@mail.gmail.com> 
 <Pine.LNX.4.64.0912091442360.30748@sister.anvils>
 <2375c9f90912092259pe86356cvb716232ba7a4d604@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1357647399-1260438996=:31654"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1357647399-1260438996=:31654
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 10 Dec 2009, Am=C3=A9rico Wang wrote:
> On Wed, Dec 9, 2009 at 10:49 PM, Hugh Dickins
> >
> > Thanks for the report. =C2=A0Not known to me.
> > It looks like something has corrupted the start of a pagetable.
                                  no, not the start
> > No idea what that something might be, but probably not bad RAM.
> >
> >>
> >> Please feel free to let me know if you need more info.
> >
> > You say you saw it twice: please post what the other occasion
> > showed (unless the first six lines were identical to this and it
> > occurred around the same time i.e. separate report of the same).
> >
>=20
> Yes, the rest are almost the same, the only difference is the 'addr'
> shows different addresses.

Please post what this other occasion showed, if you still have the log.

Hugh
--8323584-1357647399-1260438996=:31654--
