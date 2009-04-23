Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbZDWPJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbZDWPJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759556AbZDWPIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:08:46 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:44928 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759540AbZDWPIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:08:45 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 000/100] 2.6.29.2 -stable review
Date: Thu, 23 Apr 2009 16:08:41 +0100
User-Agent: KMail/1.9.10
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "stable@kernel.org" <stable@kernel.org>, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Jake Edge <jake@lwn.net>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       Chuck Wolber <chuckw@quantumlinux.com>
References: <20090423072020.428683652@sous-sol.org> <200904231556.38723.tvrtko.ursulin@sophos.com> <20090423150200.GA26871@kroah.com>
In-Reply-To: <20090423150200.GA26871@kroah.com>
MIME-Version: 1.0
Message-Id: <200904231608.42147.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/04/2009 16:08:42,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/04/2009 16:08:43,
	Serialize complete at 23/04/2009 16:08:43
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009 16:02:00 Greg KH wrote:
[snip]
> > > > Hi,
> > > >
> > > > Could you please include a fix for forcedeth resume from hibernation
> > > > regression as well?
> > > >
> > > > http://marc.info/?l=linux-netdev&m=123885046818928&w=4
> > >
> > > Do you have the git commit id of this patch in Linus's tree?
> >
> > It should be this one 35a7433c789ba6df6d96b70fa745ae9e6cac0038.
>
> Looks good, we should queue it up for the next release (at 100 patches,
> this one looks pretty full...)

OK, but if at all possible please squeeze it in in .2. I copied stable twice I 
think during the discussion about this regression which was almost one month 
ago now.

Tvrtko
