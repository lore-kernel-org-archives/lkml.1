Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbZDWO5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbZDWO5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbZDWO4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:56:42 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:42733 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759314AbZDWO4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:56:40 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 000/100] 2.6.29.2 -stable review
Date: Thu, 23 Apr 2009 15:56:37 +0100
User-Agent: KMail/1.9.10
Cc: Chris Wright <chrisw@sous-sol.org>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Jake Edge <jake@lwn.net>, Chuck Wolber <chuckw@quantumlinux.com>,
       "stable@kernel.org" <stable@kernel.org>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
References: <20090423072020.428683652@sous-sol.org> <200904231447.50809.tvrtko.ursulin@sophos.com> <20090423144918.GA26433@kroah.com>
In-Reply-To: <20090423144918.GA26433@kroah.com>
MIME-Version: 1.0
Message-Id: <200904231556.38723.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/04/2009 15:56:39,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 23/04/2009 15:56:39,
	Serialize complete at 23/04/2009 15:56:39
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009 15:49:18 Greg KH wrote:
> On Thu, Apr 23, 2009 at 02:47:50PM +0100, Tvrtko Ursulin wrote:
> > On Thursday 23 April 2009 08:20:20 Chris Wright wrote:
> > > This is the start of the stable review cycle for the 2.6.29.2 release.
> > > There are 100 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let us know.  If anyone is a maintainer of the proper subsystem, and
> > > wants to add a Signed-off-by: line to the patch, please respond with
> > > it.
> > >
> > > These patches are sent out with a number of different people on the
> > > Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> > > to add your name to the list.  If you want to be off the reviewer list,
> > > also email us.
> > >
> > > Responses should be made by Sat, Apr 25, 07:00 UTC.  Anything received
> > > after that time might be too late.
> >
> > Hi,
> >
> > Could you please include a fix for forcedeth resume from hibernation
> > regression as well?
> >
> > http://marc.info/?l=linux-netdev&m=123885046818928&w=4
>
> Do you have the git commit id of this patch in Linus's tree?

It should be this one 35a7433c789ba6df6d96b70fa745ae9e6cac0038.

Thanks,

Tvrtko
