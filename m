Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXFXV3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXFXV3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbXFXV3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:29:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37133 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbXFXV3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:29:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Please release a stable kernel Linux 3.0
Date: Sun, 24 Jun 2007 22:54:59 +0200
User-Agent: KMail/1.9.5
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       =?iso-8859-1?q?Zolt=E1n_HUBERT?= <zoltan.hubert@zzaero.com>,
       linux-kernel@vger.kernel.org
References: <200706212349.54983.zoltan.hubert@zzaero.com> <200706221700.08135.rjw@sisk.pl> <467C02AA.2080105@redhat.com>
In-Reply-To: <467C02AA.2080105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706242254.59695.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 June 2007 19:11, Chuck Ebbert wrote:
> On 06/22/2007 11:00 AM, Rafael J. Wysocki wrote:
> > On Friday, 22 June 2007 00:34, Chuck Ebbert wrote:
> >> On 06/21/2007 06:29 PM, Jesper Juhl wrote:
> >>> I myself have argued that we should be focusing more on stability and
> >>> regression fixing, but I'm not so sure that a 2.6.7 devel branch would
> >>> solve this. In general the 2.6.x.y -stable kernels seem to be doing
> >>> the job pretty good.
> >>>
> >>  
> >> Even the good ones that get lots of fixes aren't all that good. The
> >> biggest problem ATM is that suspend is badly broken and keeps getting
> >> worse...
> > 
> > Can you please provide me with any links to suspend-related bug reports from
> > you?
> > 
> 
> I get so many suspend/resume bug reports that I've given up trying
> to get them fixed. And there are so many bugs that are even worse,
> like crashes during normal use, data corruption, etc. that suspend
> bugs don't get much attention. But here are the ones for Fedora 6;
> the list would be much longer if I included Fedora 5 and 7:

Can you please tell me what's the relationship between Fedora kernel vesions
and the kernel.org kernels?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
